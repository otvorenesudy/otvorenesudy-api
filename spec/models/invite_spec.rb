require 'rails_helper'

RSpec.describe Invite, type: :model do
  it 'requires email' do
    invite = build(:invite, email: nil)

    expect(invite).not_to be_valid

    invite = build(:invite, email: 'example@gmail.com')

    expect(invite).to be_valid
  end
end
