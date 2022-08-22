class FollowingController < ApplicationController
  before_action :logged_in_user, :find_user_by_id, only: :index

  def index
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.follow.USER_PER_PAGE
    render "users/show_follow"
  end
end
