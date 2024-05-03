# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'api/key', aliases: [:api_key] do
    # value is generated automaticly upon creation
  end
end
