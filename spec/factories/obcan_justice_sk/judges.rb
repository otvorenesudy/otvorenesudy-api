# == Schema Information
#
# Table name: obcan_justice_sk_judges
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  uri        :string           not null
#  data       :jsonb            not null
#  checksum   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'obcan_justice_sk/judge', aliases: [:obcan_justice_sk_judge] do
    sequence(:guid) { |n| n.to_s }
    sequence(:uri) { |n| "https://obcan.justice.sk/judges/#{n}" }

    data { { 'registreGuid' => guid, 'meno' => 'Example Judge' } }
    checksum { Digest::SHA256.hexdigest(data.to_json) }
  end
end
