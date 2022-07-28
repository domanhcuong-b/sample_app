class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path, alert: t(".user_not_found")
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash[:alert] = t ".sign_up_fail"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(User::UPDATETABLE_ATTRS)
  end
end
