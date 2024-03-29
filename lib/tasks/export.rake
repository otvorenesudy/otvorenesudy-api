namespace :export do
  desc 'Export decrees'
  task decrees: :environment do
    ExportDecreesJob.enqueue(location: ENV['STORE'])
  end

  desc 'Export Public::ProsecutorRefinements into CSV'
  task public_prosecutor_refinements: :environment do
    CSV.open(Rails.root.join("tmp/public-prosecutor-refinements-#{Time.now.strftime('%Y%m%d%H%M')}.csv"), "w") do |csv|
      Public::ProsecutorRefinement.order(:created_at).find_each do |refinement|
        csv << [refinement.name, refinement.email, refinement.ip_address, refinement.prosecutor, refinement.office, refinement.created_at]
      end
    end
  end

  desc 'Export hearings'
  task hearings: :environment do  
    path = ENV['STORE']
    digits = ENV['DIGITS']

    pre_path = File.join(path, 'pre-2016')
    post_path = File.join(path, 'post-2016')

    FileUtils.mkdir_p(pre_path)
    FileUtils.mkdir_p(post_path)

    InfoSud::Hearing.order(created_at: :asc).find_in_batches(batch_size: 10_000).with_index do |hearings, i|
      start = Time.now

      data = hearings.map do |hearing|
        uri = "https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/#{hearing.data['guid']}"
        id = ::Hearing.find_by(uri: uri)&.id

        data = hearing.data.slice(
          "ecli",
          "guid",
          "usek",
          "predmet",
          "sud_typ",
          "poznamka",
          "sud_guid",
          "sud_kraj",
          "miestnost",
          "sud_nazov",
          "sud_okres",
          "sudca_guid",
          "sudca_meno",
          "forma_ukonu",
          "je_samosudca",
          "spisova_znacka",
          "datum_zapocatia",
          "datum_a_cas_pojednavania",
          "identifikacne_cislo_spisu"
        )

        data["navrhovatel"] = hearing.data['navrhovatel']&.map { HearingReconciler::RandomInitialsProvider.provide }
        data["mena_odporcov"] = hearing.data['mena_odporcov']&.map { HearingReconciler::RandomInitialsProvider.provide }
        data["mena_obzalovanych"] = hearing.data['mena_obzalovanych']&.map { HearingReconciler::RandomInitialsProvider.provide }

        data['__otvorenesudy__'] = {
          'info_sud_uri' => "https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/#{hearing.data['guid']}"
        }

        if id
          data['__otvorenesudy__']['otvorenesudy_id'] = id
          data['__otvorenesudy__']['otvorenesudy_uri'] = "https://otvorenesudy.sk/hearings/#{id}"
        end

        data
      end

      time = Time.now - start
      filename = "#{"%0#{digits}d" % i}.json"

      File.open(File.join(post_path, filename), 'w') do |f|
        f.write(JSON.pretty_generate(data))
      end

      puts "Exported [post-2016] batch [#{i}] [#{filename}] in [#{time}] seconds"
    end

    Hearing.where("uri LIKE '%www.justice.gov.sk%'").order(created_at: :asc).includes(:section, :subject, :form, :court, :judges, :proceeding, :proposers, :opponents, :defendants).find_in_batches(batch_size: 10_000).with_index do |hearings, i|
      start = Time.now

      data = hearings.map do |hearing|
        court_guid = hearing.court ? hearing.court.uri.split('/').last : nil
        info_sud_court = court_guid ? InfoSud::Court.find_by(guid: court_guid) : nil
        judges = hearing.judges
        judge_guids = judges.map(&:uri).map { |uri| uri.match(/sudca_\d+\z/) ? uri.split('/').last.gsub(/^sudca_/, '') : nil }
        proceeding = hearing.proceeding
        eclis = proceeding ? proceeding.decrees.order(created_at: :asc).pluck(:ecli) : []

        data = {
          "ecli": eclis.first,
          "guid": nil,
          "usek": hearing.section&.value,
          "predmet": hearing.subject&.value,
          "sud_typ": info_sud_court ? info_sud_court.data['typ'] : nil,
          "poznamka": hearing.note,
          "sud_guid": court_guid&.gsub('^sud_', ''),
          "sud_kraj": info_sud_court ? info_sud_court.data['kraj'] : nil,
          "miestnost": hearing.room,
          "sud_nazov": info_sud_court ? info_sud_court.data['nazov'] : nil,
          "sud_okres": info_sud_court ? info_sud_court.data['okres'] : nil,
          "sudca_guid": judge_guids,
          "sudca_meno": judges.map(&:name),
          "forma_ukonu": hearing.form&.value,
          "je_samosudca": hearing.selfjudge,
          "spisova_znacka": hearing.case_number,
          "datum_zapocatia": nil,
          "datum_a_cas_pojednavania": hearing.date,
          "identifikacne_cislo_spisu": hearing.file_number
        }

        data["navrhovatel"] = hearing.proposers.map { HearingReconciler::RandomInitialsProvider.provide }
        data["mena_odporcov"] = hearing.opponents.map { HearingReconciler::RandomInitialsProvider.provide }
        data["mena_obzalovanych"] = hearing.defendants.map { HearingReconciler::RandomInitialsProvider.provide }

        data['__otvorenesudy__'] = {
          'justice_gov_sk_uri' => hearing.uri,
          'otvorenesudy_id' => hearing.id,
          "otvorenesudy_uri" => "https://otvorenesudy.sk/hearings/#{hearing.id}",
          "ecli": eclis,
        }

        data
      end

      time = Time.now - start

      filename = "#{"%0#{digits}d" % i}.json"
        
      File.open(File.join(pre_path, filename), 'w') do |f|
        f.write(JSON.pretty_generate(data))
      end

      puts "Exported [pre-2016] batch [#{i}] [#{filename}] in [#{time}] seconds"
    end
  end

  desc 'Hearings export validation and stats'
  task validate_hearings: :environment do
    path = ENV['STORE']
    pre_path = File.join(path, 'pre-2016')
    post_path = File.join(path, 'post-2016')

    data = []

    puts 'Loading [pre-2016] data ...'

    Dir.glob(File.join(pre_path, '*.json')).each do |filename|
      data += JSON.parse(File.read(filename))
    end
    
    puts 'Loading [post-2016] data ...'

    Dir.glob(File.join(post_path, '*.json')).each do |filename|
      data += JSON.parse(File.read(filename))
    end

    puts 'Validating ...'

    stats = {
      'Empty Participants' => 0,
      'No Court' => 0,
      'No Judges' => 0
    }

    all_names = {}

    data.each do |hearing|
      # Validate anonymization format
      names = [hearing["navrhovatel"], hearing["mena_odporcov"], hearing["mena_obzalovanych"]].flatten.compact

      raise "Incorrect anonymization format: #{hearing.inspect}" if names.any? { |name| !name.match(/^[A-Z]\.\s[A-Z]\.$/) }

      # Compute stats
      stats['Empty Participants'] += 1 if names.empty?
      stats['No Court'] += 1 unless hearing['sud_guid']
      stats['No Judges'] += 1 if hearing['sudca_guid']&.empty?

      names.each do |name|
        all_names[name] ||= 0
        all_names[name] += 1
      end
    end

    puts "Database Hearings: #{Hearing.count}"
    puts "Hearings in Export: #{data.size}"
    puts "\nStats:"
    puts JSON.pretty_generate(stats)
    puts "\nParticipants Distribution:"
    puts JSON.pretty_generate(all_names)
  end
end
