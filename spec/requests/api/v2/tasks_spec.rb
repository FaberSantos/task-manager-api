require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
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

  before { host! 'api.supertasks.dev' }

  # action index
  describe 'GET /tasks' do

    context 'when no search parameter' do
      before do
        create_list(:task, 5, user_id: user.id)
        get '/tasks', params: {}.to_json, headers: headers
      end
      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 items' do
        expect(json_body[:data].count).to eq(5)
      end
    end

    context 'when filter and/or sort params are sent' do
      let!(:notebook_task_1) { create(:task, title: 'B Notebook Task 1', user_id: user.id) }
      let!(:notebook_task_2) { create(:task, title: 'A Notebook Task 2', user_id: user.id) }
      let!(:car_task_1) { create(:task, title: 'Buy Car Task 1', user_id: user.id) }
      let!(:car_task_2) { create(:task, title: 'Buy Car Task 2', user_id: user.id) }
      let!(:other_task_1) { create(:task, title: 'Other task', user_id: user.id) }

      before do
        get '/tasks', params: { q: { title_cont: 'note', s: 'title DESC' } }, headers: headers
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns titles array items' do
        returned_titles = json_body[:data].map { |t| t[:attributes][:title] }
        expect(returned_titles).to eq([notebook_task_1.title, notebook_task_2.title])
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
        expect(json_body[:data][:attributes][:title]).to eq(task.title)
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

  #action create
  describe 'POST /tasks' do
    let!(:task) { create(:task, user_id: user.id) }
    before do
      post '/tasks', params: {task: task_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:task_params) { attributes_for(:task) }

      it 'returns record created - 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'task is assigned for current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when the request params are invalid' do
      let(:task_params) { attributes_for(:task, title: nil) }

      it 'returns record created - 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  #action update
  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    let!(:task_id) { task.id }
    before do
      put "/tasks/#{task_id}", params: {task: task_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:task_params) { {description: 'shfdksjhfdsakjdhf' } }

      it 'returns record updated successfully - 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for updated task' do
        expect(json_body[:data][:attributes][:description]).to eq(task_params[:description])
      end
    end

    context 'when the request params are invalid' do
      let(:task_params) { attributes_for(:user, title: nil) }

      it 'returns record created - 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  #action delete
  describe 'DELETE /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    let!(:task_id) { task.id }
    before do
      delete "/tasks/#{task_id}", params: {}.to_json, headers: headers
    end

    context 'when the request params are valid' do

      it 'returns record deleted successfully - 204' do
        expect(response).to have_http_status(204)
      end

      it 'user removed from database' do
        expect(Task.find_by(id: task_id)).to be_nil
      end

    end


  end
  
end
