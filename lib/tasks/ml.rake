def batch_decrees(batch_size: 10_000, include_text: false)
  last_id = 0
  columns = %i[id form court_type year natures legislation_areas legislation_subareas legislations text]

  loop do
    records = nil
    timing =
      Benchmark.measure do
        records =
          Decree
            .left_outer_joins(:form, :natures, :legislation_areas, :legislation_subareas, :legislations, court: :type)
            .where('decrees.id > ?', last_id)
            .group(:id)
            .order(id: :asc)
            .limit(batch_size)
            .pluck(
              :id,
              Arel.sql('MIN(decree_forms.value)'),
              Arel.sql('MIN(court_types.value)'),
              Arel.sql('EXTRACT(YEAR FROM date) :: INTEGER'),
              Arel.sql('ARRAY_AGG(DISTINCT decree_natures.value) FILTER (WHERE decree_natures.value IS NOT NULL)'),
              Arel.sql(
                'ARRAY_AGG(DISTINCT legislation_areas.value) FILTER (WHERE legislation_areas.value IS NOT NULL)'
              ),
              Arel.sql(
                'ARRAY_AGG(DISTINCT legislation_subareas.value) FILTER (WHERE legislation_subareas.value IS NOT NULL)'
              ),
              Arel.sql('ARRAY_AGG(DISTINCT legislations.value) FILTER (WHERE legislations.value IS NOT NULL)'),
              Arel.sql(
                "
                  ARRAY_TO_STRING(
                    (
                      SELECT ARRAY_AGG(decree_pages.text ORDER BY decree_pages.number ASC) FROM decree_pages
                      WHERE decree_pages.decree_id = decrees.id
                      GROUP BY decree_pages.decree_id
                    ),
                    ''
                  ) AS text
                "
              )
            )
      end

    break if records.blank?

    puts("Fetching decrees took [#{timing.real.round(3)}] seconds")

    yield records.map { |row| columns.zip(row).to_h }

    last_id = records.last[0]
  end
end

namespace :ml do
  task base_embed_decrees: :environment do
    path = "/tmp/decrees-embeddings-#{Time.now.strftime('%Y%m%d%H%M')}"

    FileUtils.mkdir_p(path)
    FileUtils.mkdir_p(File.join(path, 'data'))

    vocabulary = [
      *Court::Type.pluck(:value),
      *Decree::Form.pluck(:value),
      *Decree::Nature.pluck(:value),
      *Legislation::Area.pluck(:value),
      *Legislation::Subarea.pluck(:value),
      *Legislation.pluck(:value)
    ]

    begin
      timing =
        Benchmark.measure { File.open(File.join(path, 'vocabulary.json'), 'w') { |f| f.write(vocabulary.to_json) } }

      puts("Building vocabulary took [#{timing.real.round(3)}] seconds")

      i = 0

      batch_decrees do |records|
        File.open(File.join(path, 'data', "#{i}.json"), 'w') { |f| f.write(records.to_json) }

        i += 1
      end

      Open3.popen3 "DATA_PATH='#{path}' python3 #{Rails.root.join('ml', 'decree-embeddings', 'base-embed.py')}" do |stdin, stdout, stderr, thread|
        while line = stdout.gets
          puts line
        end
      end

      Dir
        .glob(File.join(path, 'data', '*.json'))
        .each do |path|
          data = JSON.parse(File.read(path), symbolize_names: true)

          data.each do |record|
            Decree.where(id: record[:id]).update_all(embedding: "[#{record[:base_embedding].join(',')}]")
          end

          puts "Saved [#{data.size}] embeddings from [#{path}] file"
        end
    ensure
      FileUtils.rm_rf(path) unless ENV['KEEP_TMP_FILES']
    end
  end
end
