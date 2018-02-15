require 'rails_helper'

RSpec.describe Invite, type: :model do
  it 'requires email' do
    invite = build(:invite, email: nil, locale: 'en')

    expect(invite).not_to be_valid
    expect(invite.errors.size).to eql(2)
    expect(invite.errors[:email].sort).to eql(['can\'t be blank', 'is invalid'].sort)

    invite = build(:invite, email: 'example@gmail.com', locale: 'en')

    expect(invite).to be_valid
  end

  it 'requires correct email format' do
    invite = build(:invite, email: 'bogus@', locale: :en)

    expect(invite).not_to be_valid
    expect(invite.errors.size).to eql(1)
    expect(invite.errors[:email]).to eql(['is invalid'])

    invite = build(:invite, email: 'example@gmail.com', locale: 'en')

    expect(invite).to be_valid
  end

  it 'requries locale' do
    invite = build(:invite, email: 'example@gmail.com', locale: nil)

    expect(invite).not_to be_valid
    expect(invite.errors.size).to eql(2)
    expect(invite.errors[:locale]).to eql(['can\'t be blank', 'is not included in the list'])

    invite = build(:invite, email: 'example@gmail.com', locale: 'en')

    expect(invite).to be_valid
  end

  it 'requires email and locale to be unique' do
    create(:invite, email: 'example@gmail.com', locale: 'en')

    invite = build(:invite, email: 'example@gmail.com', locale: 'en')

    expect(invite).not_to be_valid
    expect(invite.errors.size).to eql(1)
    expect(invite.errors[:email]).to eql(['has already been taken'])

    invite = build(:invite, email: 'example@gmail.com', locale: 'sk')

    expect(invite).to be_valid
  end
end
