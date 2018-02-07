class Api::V1::TasksController < ApplicationController

  before_action :authenticate_with_token!
  before_action :set_task, only: [:show]

  def index
    @tasks = current_user.tasks
    render json: { tasks: @tasks }, status: 200
  end

  def show
    render json: @task, status: 200
  end


  private

  def set_task
    begin
      @task = current_user.tasks.find(params[:id])
    rescue
      head 404
    end
  end
end
