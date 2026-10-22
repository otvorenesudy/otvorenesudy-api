# frozen_string_literal: true

require 'rails_helper'

# The Sidekiq dashboard lists, retries and deletes this app's jobs: only with the password from the credentials.
RSpec.describe 'Sidekiq dashboard' do
  def authorization(password)
    ActionController::HttpAuthentication::Basic.encode_credentials('admin', password)
  end

  # The credentials are configuration we don't own here: the tests have none, so the password is given.
  before do
    credentials = Rails.application.credentials

    allow(credentials).to receive(:dig).and_call_original
    allow(credentials).to receive(:dig).with(:sidekiq, :password).and_return('dashboard password') # betterleaks:allow
  end

  it 'asks for the password' do
    get '/sidekiq'

    expect(response).to have_http_status(:unauthorized)
  end

  it 'refuses a wrong password' do
    get '/sidekiq', headers: { 'HTTP_AUTHORIZATION' => authorization('guess') }

    expect(response).to have_http_status(:unauthorized)
  end

  it 'opens with the password' do
    get '/sidekiq', headers: { 'HTTP_AUTHORIZATION' => authorization('dashboard password') } # betterleaks:allow

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Sidekiq')
  end
end
