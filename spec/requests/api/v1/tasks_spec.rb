require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let!(:user) { create(:user) }

  let!(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  before { host! 'api.supertasks.dev' }

  # action index
  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}.to_json, headers: headers
    end

    context 'when return list successfully' do

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 items' do
        expect(json_body['tasks'].count).to eq(5)
      end
      
    end
  end

  # action show
  describe 'GET /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    let!(:task_id) { task.id }

    before do
      get "/tasks/#{task_id}", params: {}.to_json, headers: headers
    end

    context 'when the task exists' do
      it 'returns the task' do
        expect(json_body['title']).to eq(task.title)
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

    end

    context 'when the task does not exist' do
      let(:task_id) { 999 }

      it 'returns code not found' do
        expect(response).to have_http_status(404)
      end

    end


  end
end
