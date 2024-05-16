namespace :ml do
  task vectorize_decrees: :environment do
    feature_values = {
      form: Decree::Form.order(value: :asc).pluck(:value),
      nature: Decree::Nature.order(value: :asc).pluck(:value),
      legislation_area: Legislation::Area.order(value: :asc).pluck(:value),
      legislation_subarea: Legislation::Subarea.order(value: :asc).pluck(:value),
      legislation: Legislation.order(value: :asc).pluck(:value)
    }

    features_map = {}

    feature_values.inject(0) do |n, (key, values)|
      values.each_with_index { |value, index| features_map["#{key}-#{value}"] = n + index }

      n + values.size
    end

    data = []

    Decree.find_each do |decree|
      e = Array.new(features_map.size, 0)

      e[features_map["form-#{decree.form.value}"]] = 1 if decree.form

      decree.natures.each { |nature| e[features_map["nature-#{nature.value}"]] = 1 }

      decree.legislation_areas.each { |area| e[features_map["legislation_area-#{area.value}"]] = 1 }

      decree.legislation_subareas.each { |subarea| e[features_map["legislation_subarea-#{subarea.value}"]] = 1 }

      decree.legislations.each { |legislation| e[features_map["legislation-#{legislation.value}"]] = 1 }

      data << [decree.id, *e]
    end

    File.open('data.json', 'w') { |file| file.write(data.to_json) }
  end
end
