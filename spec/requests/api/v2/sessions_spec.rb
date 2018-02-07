require 'rails_helper'


RSpec.describe 'Sessions API', type: :request do
  before { host! 'api.supertasks.dev' }
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let!(:headers) do
    {
        'Accept' => 'application/vnd.taskmanager.v2',
        'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /sessions' do
    before do
      post '/sessions', params: {session: credentials }.to_json, headers: headers
    end

    context 'when credentials are valid' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for user with auth_token' do
        user.reload
        expect(json_body['auth_token']).to eq(user.auth_token)
      end

    end

    context 'when credentials are not valid' do
      let(:credentials) { { email: user.email, password: '1234567' } }

      it 'returns record created - 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key('errors')
      end

    end

  end

  describe 'DELETE /sessions/:id' do
    let(:auth_token) { user.auth_token }

    before do
      delete "/sessions/#{auth_token}", params: {}.to_json, headers: headers
    end

    context 'when the request params are valid' do

      it 'returns record deleted successfully - 204' do
        expect(response).to have_http_status(204)
      end

      it 'session token has changed removed from database' do
        expect(User.find_by(auth_token: auth_token)).to be_nil
      end

    end

  end


end