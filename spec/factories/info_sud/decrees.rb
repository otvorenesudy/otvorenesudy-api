FactoryGirl.define do
  factory :'info_sud/decree', aliases: [:info_sud_decree] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        identifikacne_cislo_spisu: '123456789'
      }
    }
  end
end
