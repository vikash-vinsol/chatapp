class UsersController < ApplicationController
  def create
    @user = User.create(user_params)
    respond_with(@user)
  end

  def check_presence
    @user_exist = User.exist_with_account_name?(params[:account_name])
  end

  private
    def user_params
      params.require(:user).permit(:account_name, :firstname, :lastname, :country_id, :mobile, :device_type, :device_token)
    end
end