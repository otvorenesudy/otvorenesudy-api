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
    i = 0
  
    path = ENV['STORE']
    digits = ENV['DIGITS']

    pre_path = File.join(path, 'pre-2016')
    post_path = File.join(path, 'post-2016')

    FileUtils.mkdir_p(pre_path)
    FileUtils.mkdir_p(post_path)

    InfoSud::Hearing.order(created_at: :asc).find_in_batches(batch_size: 10_000) do |hearings|
      start = Time.now

      i += 1

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

      puts "Exported [pre-2016] batch [#{i}] [#{filename}] in [#{time}] seconds"
    end

    Hearing.where("uri LIKE '%www.justice.gov.sk%'").order(created_at: :asc).find_in_batches(batch_size: 10_000) do |hearings|
      start = Time.now

      i += 1

      data = hearings.map do |hearing|
        court_guid = hearing.court&.uri.split('/').last
        info_sud_court = court_guid ? InfoSud::Court.find_by(guid: court_guid) : nil
        judges = hearing.judges
        judge_guids = judges.map(&:uri).map { |uri| uri.match(/sudca_\d+\z/) ? uri.split('/').last.gsub(/^sudca_/, '') : nil }
        proceeding = hearing.proceeding

        data = {
          "ecli": proceeding ? proceeding.decrees.order(created_at: :asc).first&.ecli : nil,
          "guid": nil,
          "usek": hearing.section&.value,
          "predmet": hearing.subject&.value,
          "sud_typ": info_sud_court&.data['typ_sudu'],
          "poznamka": hearing.note,
          "sud_guid": court_guid&.gsub('^sud_', ''),
          "sud_kraj": info_sud_court&.data['kraj'],
          "miestnost": hearing.room,
          "sud_nazov": info_sud_court&.data['nazov'],
          "sud_okres": info_sud_court&.data['okres'],
          "sudca_guid": judge_guids,
          "sudca_meno": judges.map(&:name),
          "forma_ukonu": hearing.form&.value,
          "je_samosudca": hearing.selfjudge,
          "spisova_znacka": proceeding&.case_number,
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
          "ecli": proceeding ? proceeding.decrees.order(created_at: :asc).pluck(:ecli) : [],
        }

        data
      end

      time = Time.now - start

      filename = "#{"%0#{digits}d" % i}.json"
        
      File.open(File.join(pre_path, filename), 'w') do |f|
        f.write(JSON.pretty_generate(data))
      end

      puts "Exported [post-2016] batch [#{i}] [#{filename}] in [#{time}] seconds"
    end
  end
end
