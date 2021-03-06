require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  before { host! 'api.supertasks.dev' }
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let!(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'POST /auth/sign_in' do
    before do
      post '/auth/sign_in', params: credentials.to_json, headers: headers
    end

    context 'when credentials are valid' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns authentication data on headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('client')
        expect(response.headers).to have_key('uid')
      end

    end

    context 'when credentials are not valid' do
      let(:credentials) { { email: user.email, password: '1234567' } }

      it 'returns record created - 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end

    end

  end

  describe 'DELETE /auth/sign_out' do
    let(:auth_token) { user.auth_token }

    before do
      delete '/auth/sign_out', params: {}.to_json, headers: headers
    end

    it 'returns record deleted successfully - 200' do
      expect(response).to have_http_status(200)
    end

    it 'session token has changed removed from database' do
      user.reload
      expect( user.valid_token?(auth_data['access-token'], auth_data['client']) ).to eq(false)
    end

  end


end