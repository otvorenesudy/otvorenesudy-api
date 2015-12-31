FactoryGirl.define do
  factory :'info_sud/court', aliases: [:info_sud_court] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        name: 'Example Court'
      }
    }
  end
end
