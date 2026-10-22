# frozen_string_literal: true

require 'rails_helper'

# Corrections to prosecutors' details that visitors of prokuratori.otvorenesudy.sk send.
RSpec.describe 'Prosecutor refinements' do
  let(:params) { { name: 'Ján Novák', email: 'jan@example.com', office: 'OP Bratislava I', prosecutors: %w[Adam Eva] } }

  def post_refinements(body, ip: '203.0.113.7')
    post '/public/prosecutor_refinements.json', params: body.to_json,
                                                headers: { 'CONTENT_TYPE' => 'application/json', 'REMOTE_ADDR' => ip }
  end

  it 'saves a refinement for each prosecutor, with the sender and their address' do
    post_refinements(params)

    expect(response).to have_http_status(:ok)
    expect(response.body).to eq(' ')
    sent = ['Ján Novák', 'jan@example.com', 'OP Bratislava I', '203.0.113.7']

    expect(Public::ProsecutorRefinement.order(:prosecutor).pluck(:prosecutor, :name, :email, :office, :ip_address))
      .to eq([['Adam', *sent], ['Eva', *sent]])
  end

  it 'allows any site to send them outside production' do
    post_refinements(params)

    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
  end

  it 'answers an invalid e-mail address with what is wrong, and saves nothing', :error_pages do
    post_refinements(params.merge(email: 'not an address'))

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to eq('{"success":false,"errors":["Email is invalid"]}')
    expect(Public::ProsecutorRefinement.count).to eq(0)
  end

  it 'saves none of the refinements when one of them is invalid', :error_pages do
    post_refinements(params.merge(prosecutors: ['Adam', '']))

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to eq(%({"success":false,"errors":["Prosecutor can't be blank"]}))
    expect(Public::ProsecutorRefinement.count).to eq(0)
  end

  it 'answers a request without prosecutors with what is missing', :error_pages do
    post_refinements(params.except(:prosecutors))

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to eq(%({"success":false,"errors":["Prosecutors can't be blank"]}))
  end

  it 'turns away an address that sent 30 refinements in the last 30 seconds' do
    post_refinements(params.merge(prosecutors: Array.new(30) { |n| "Prosecutor #{n}" }))
    post_refinements(params)

    expect(response).to have_http_status(:too_many_requests)
    expect(Public::ProsecutorRefinement.count).to eq(30)
  end

  it 'takes refinements from another address meanwhile' do
    post_refinements(params.merge(prosecutors: Array.new(30) { |n| "Prosecutor #{n}" }))
    post_refinements(params, ip: '203.0.113.8')

    expect(response).to have_http_status(:ok)
    expect(Public::ProsecutorRefinement.where(ip_address: '203.0.113.8').count).to eq(2)
  end
end
