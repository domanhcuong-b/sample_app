class UsersController < ApplicationController
  before_action :find_user_by_id, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.order_by_time_created,
                         items: Settings.user.admin.USER_PER_PAGE
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:info] = t ".check_email_to_active"
      redirect_to login_url
    else
      flash[:alert] = t ".sign_up_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash[:danger] = t ".updating_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(User::UPDATETABLE_ATTRS)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t ".incorrect_user"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t ".user_not_found"
    redirect_to root_path
  end
end
