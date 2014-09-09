class UsersController < ApplicationController
  def check_presence
    @user_exist = User.exist_with_account_name?(params[:account_name])
  end
end