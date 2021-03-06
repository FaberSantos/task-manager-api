class Api::V1::TasksController < Api::V1::BaseController

  before_action :authenticate_with_token!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @tasks = current_user.tasks
    render json: { tasks: @tasks }, status: 200
  end

  def show
    render json: @task, status: 200
  end

  def create
    begin
        @task = current_user.tasks.new(task_params)
  
        if @task.save
          render json: @task, status: 201
        else
          #byebug
          render json: { errors: @task.errors }, status: 422
        end
      rescue
        head 404
      end
  end


    def update

        if @task.update(task_params)
            render json: @task, status: 200
        else
            #byebug
            render json: { errors: @task.errors }, status: 422
        end

    end

    def destroy
        @task.destroy
      end

  private

  def set_task
    begin
      @task = current_user.tasks.find(params[:id])
    rescue
      head 404
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :done, :user_id)
  end

end
