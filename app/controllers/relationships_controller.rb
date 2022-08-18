class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :find_followed_to_follow, only: :create
  before_action :load_relationship, :find_followed_to_unfollow, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def find_followed_to_follow
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:warning] = t ".followed_user_not_found"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:warning] = t ".not_found_relationship"
    redirect_to root_path
  end

  def find_followed_to_unfollow
    @user = @relationship.followed
    return if @user

    flash[:warning] = t ".followed_user_not_found"
    redirect_to root_path
  end
end
