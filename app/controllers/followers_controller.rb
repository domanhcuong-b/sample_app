class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user_by_id, only: :index

  def index
    @title = t "followers"
    @pagy, @users = pagy @user.followers, items: Settings.follow.USER_PER_PAGE
    render "users/show_follow"
  end
end
