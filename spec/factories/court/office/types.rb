FactoryGirl.define do
  factory :'court/office/type', aliases: [:court_office_type] do
    sequence(:value) { |n| "Court Office Type ##{n}" }
  end
end
