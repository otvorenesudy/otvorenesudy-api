FactoryGirl.define do
  factory :'info_sud/judge', aliases: [:info_sud_judge] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        meno: 'Example Judge'
      }
    }
  end
end
