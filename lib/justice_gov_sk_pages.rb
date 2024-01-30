module JusticeGovSkPages
  def self.scrape
    begin
      total_courts = 0
      data =
        JSON.parse(
          Curl.get(
            'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud?page=1&size=50&sortDirection=ASC&sortProperty=typSudu_sort'
          ).body_str,
          symbolize_names: true
        )
      total_pages = data[:numFound] / data[:size].to_f
      total_remote_courts = data[:numFound]

      (1..total_pages.ceil).each do |page|
        links =
          JSON.parse(
            Curl.get(
              "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud?page=#{page}&size=50&sortDirection=ASC&sortProperty=typSudu_sort"
            ).body_str,
            symbolize_names: true
          )[
            :sudList
          ].map { |court| "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud/#{court[:registreGuid]}" }

        links.each { |link| JusticeGovSkPages::Job.perform_later('court', link) }

        total_courts += links.count
      end
    rescue StandardError => e
      puts e.backtrace
    end

    begin
      total_judges = 0
      data =
        JSON.parse(
          Curl.get('https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca?page=1&size=50').body_str,
          symbolize_names: true
        )
      total_pages = data[:numFound] / data[:size].to_f
      total_remote_judges = data[:numFound]

      (1..total_pages.ceil).each do |page|
        links =
          JSON.parse(
            Curl.get("https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca?page=#{page}&size=50").body_str,
            symbolize_names: true
          )[
            :sudcaList
          ].map { |court| "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca/#{court[:registreGuid]}" }

        links.each { |link| JusticeGovSkPages::Job.perform_later('judge', link) }

        total_judges += links.count
      end
    rescue StandardError => e
      puts e.backtrace
    end

    begin
      total_criminal_hearings = 0
      data =
        JSON.parse(
          Curl.get(
            'https://api.justice.gov.sk/pojednavanie/trestne?skip=0&take=50&filter.datumPojednavaniaOd=2024-01-29&sortCriteria[0].fieldName=DatumPojednavania&sortCriteria[0].direction=Ascending'
          ).body_str,
          symbolize_names: true
        )
      total_pages = data[:filteredCount] / data[:take]
      total_remote_criminal_hearings = data[:filteredCount]

      (0..total_pages.ceil).each do |page|
        links =
          JSON.parse(
            Curl.get(
              "https://api.justice.gov.sk/pojednavanie/trestne?skip=#{page * data[:take]}&take=50&filter.datumPojednavaniaOd=2024-01-29&sortCriteria[0].fieldName=DatumPojednavania&sortCriteria[0].direction=Ascending"
            ).body_str,
            symbolize_names: true
          )[
            :data
          ].map { |hearing| "https://api.justice.gov.sk/pojednavanie/trestne/#{hearing[:id]}" }

        links.each { |link| JusticeGovSkPages::Job.perform_later('hearing', link) }

        total_criminal_hearings += links.count
      end
    rescue StandardError => e
      puts e.backtrace
    end

    begin
      total_civil_hearings = 0
      data =
        JSON.parse(
          Curl.get(
            'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/obcianPojednavania?page=1&size=50&sortDirection=DESC&sortProperty=datum_a_cas_pojednavania'
          ).body_str,
          symbolize_names: true
        )
      total_pages = data[:numFound] / data[:size].to_f
      total_remote_civil_hearings = data[:numFound]

      (1..total_pages.ceil).each do |page|
        links =
          JSON.parse(
            Curl.get(
              "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/obcianPojednavania?page=#{page}&size=50&sortDirection=DESC&sortProperty=datum_a_cas_pojednavania"
            ).body_str,
            symbolize_names: true
          )[
            :obcianPojednavaniaList
          ].map do |hearing|
            "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/obcianPojednavania/#{hearing[:guid]}"
          end

        links.each { |link| JusticeGovSkPages::Job.perform_later('hearing', link) }

        total_civil_hearings += links.count
      end
    rescue StandardError => e
      puts e.backtrace
    end

    begin
      total_decrees = 0
      data =
        JSON.parse(
          Curl.get('https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie?page=1&size=50').body_str,
          symbolize_names: true
        )
      total_pages = data[:numFound] / data[:size].to_f
      total_remote_decrees = data[:numFound]

      (1..total_pages.ceil).each do |page|
        links =
          JSON.parse(
            Curl.get(
              "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie?page=#{page}&size=50"
            ).body_str,
            symbolize_names: true
          )[
            :rozhodnutieList
          ].map { |decree| "https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie/#{decree[:guid]}" }

        links.each { |link| JusticeGovSkPages::Job.perform_later('decree', link) }

        total_decrees += links.count
      end
    rescue StandardError => e
      puts e.backtrace
    end

    puts "Total Courts: Local = #{total_courts}, Remote = #{total_remote_courts}"
    puts "Total Judges: Local = #{total_judges}, Remote = #{total_remote_judges}"
    puts "Total Criminal Hearings: Local = #{total_criminal_hearings}, Remote = #{total_remote_criminal_hearings}"
    puts "Total Civil Hearings: Local = #{total_civil_hearings}, Remote = #{total_remote_civil_hearings}"
    puts "Total Decrees: Local = #{total_decrees}, Remote = #{total_remote_decrees}"
  end

  class Job < ActiveJob::Base
    queue_as :justice_gov_sk_pages

    def perform(model, uri)
      data = JSON.parse(Curl.get(uri).body_str, symbolize_names: true)

      record = JusticeGovSkPage.find_or_initialize_by(uri: uri)

      record.model = model
      record.data = data

      record.save!
    end
  end
end
