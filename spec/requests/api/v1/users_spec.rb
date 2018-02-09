require 'rails_helper'


RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let!(:headers) do
    {
        'Accept' => 'application/vnd.taskmanager.v1',
        'Content-Type' => Mime[:json].to_s,
        'Authorization' => user.auth_token
    }
  end

  before { host! 'api.supertasks.dev' }

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}.to_json, headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        expect(json_body[:id]).to eq(user_id)
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the user does not exist' do
      let(:user_id) { 999 }

      it 'returns code not found' do
        expect(response).to have_http_status(404)
      end

    end


  end

  describe 'POST /users' do
    before do
      post '/users', params: {user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns record created - 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid') }

      it 'returns record created - 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: {user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { {email: 'xxx@xxx.com' } }

      it 'returns record updated successfully - 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid') }

      it 'returns record created - 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}.to_json, headers: headers
    end

    context 'when the request params are valid' do

      it 'returns record deleted successfully - 204' do
        expect(response).to have_http_status(204)
      end

      it 'user removed from database' do
        expect(User.find_by(id: user.id)).to be_nil
      end

    end


  end


end