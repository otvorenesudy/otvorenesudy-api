namespace :info_sud do
  task import_hearings: :environment do
    InfoSud.import_hearings
  end

  task import_decrees: :environment do
    InfoSud.import_decrees
  end
end
