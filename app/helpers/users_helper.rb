module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.user_not_found"
    redirect_to root_path
  end

  def build_active_relationship
    current_user.active_relationships.build
  end

  def find_active_relationship
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
