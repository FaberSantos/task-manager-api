class Api::V1::UsersController < ApplicationController

  before_action :set_user, only: [:update, :destroy]
 # before_action :authenticate_with_token, only: [:update, :destroy]

  respond_to :json

  def show
    begin
      @user = User.find(params[:id])
      respond_with @user
    rescue
      head 404
    end

  end

  def create
    begin
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: 201
      else
        #byebug
        render json: { errors: @user.errors }, status: 422
      end
    rescue
      head 404
    end

  end


  def update

    if @user.update(user_params)
      render json: @user, status: 200
    else
      #byebug
      render json: { errors: @user.errors }, status: 422
    end

  end


  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end



end
