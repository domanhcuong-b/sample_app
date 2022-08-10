class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)
  before_action :find_user_reset, only: :create

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t ".send_email_reset_password"
    redirect_to root_path
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".cannot_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".reset_success"
      redirect_to @user
    else
      handle_update_password_error
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.user_not_found"
    redirect_to root_path
  end

  def find_user_reset
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    flash[:danger] = t "users.user_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".invalid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".email_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::RESET_PASSWORD_ATTRS
  end

  def handle_update_password_error
    flash.now[:danger] = t ".system_error"
    render :edit
  end
end
