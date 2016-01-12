FactoryGirl.define do
  factory :'info_sud/hearing', aliases: [:info_sud_hearing] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        identifikacne_cislo_spisu: '123456789'
      }
    }
  end
end
