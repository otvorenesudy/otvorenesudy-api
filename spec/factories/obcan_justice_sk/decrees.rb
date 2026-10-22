# frozen_string_literal: true

FactoryBot.define do
  factory :'obcan_justice_sk/decree', aliases: [:obcan_justice_sk_decree] do
    sequence(:guid, &:to_s)
    sequence(:uri) { |n| "https://obcan.justice.sk/decrees/#{n}" }

    data { { 'guid' => guid } }
    checksum { Digest::SHA256.hexdigest(data.to_json) }
  end
end
