require 'rails_helper'

RSpec.describe Authenticable do

  controller(ApplicationController) do
    include Authenticable
  end

  let(:app_controller) { subject }


  describe '#current_user' do
    let(:user) { create(:user) }

    before do
      req = double(:headers => { 'Authorization' => user.auth_token })
      # req.headers['Authorization']
      allow(app_controller).to receive(:request).and_return(req)
    end

    it 'returns user by authorization token on header' do
      expect(app_controller.current_user).to eq(user)
    end
  end


  describe '#authenticate_with_token!' do
    controller do
      before_action :authenticate_with_token!

      def restricted_action; end

    end

    context 'when there is no logged user' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
        routes.draw { get 'restricted_action' => 'anonymous#restricted_action' }
        get :restricted_action
      end

      it 'return status 401' do
        expect(response).to have_http_status(401)
      end

      it 'return json with errors' do
        expect(json_body).to have_key('errors')
      end
    end
  end
end