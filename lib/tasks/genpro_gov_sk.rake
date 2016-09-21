namespace :genpro_gov_sk do
  desc 'Export property declarations'
  task export_property_declarations: :environment do
    filename = Rails.root.join("tmp/prosecutors-property-declarations-#{Time.now.strftime('%Y%m%d%H%M%S')}.json")

    GenproGovSk.export_property_declarations(path: filename)
  end
end
