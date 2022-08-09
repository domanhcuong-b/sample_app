class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      handle_invalid_authenticate
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def handle_invalid_authenticate
    flash.now[:danger] = t ".invalid_email_password"
    render :new
  end
end
