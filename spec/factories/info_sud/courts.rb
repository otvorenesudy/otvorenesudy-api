FactoryGirl.define do
  factory :'info_sud/court', aliases: [:info_sud_court] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        nazov: 'Example Court'
      }
    }
  end
end
