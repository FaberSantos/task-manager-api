class Api::V1::SessionsController < Api::V1::BaseController

  respond_to :json

  def create
    @user = User.find_by(email: session_params[:email])

    if @user && @user.valid_password?(session_params[:password])
      # sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render json: @user
    else
      render json: { errors: @user.errors }, status: 401
    end


  end

  def destroy
    @user = User.find_by(auth_token: params[:id])
    @user.generate_authentication_token!
    @user.save
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :subdomain, :format, :auth)
  end

end
