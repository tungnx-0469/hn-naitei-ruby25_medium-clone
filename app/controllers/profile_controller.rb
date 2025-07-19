class ProfileController < ApplicationController
  before_action :set_user
  def show
    @article = Article.new
  end

  def followers
    @users = @user.followers
    @title = t "profile.show.followers"
    render "relationships_list"
  end

  def following
    @users = @user.following
    @title = t "profile.show.following"
    render "relationships_list"
  end

  private
  def set_user
    @user = User.includes(:articles).find_by(id: params[:id])
    return if @user

    redirect_to root_path, alert: t("msg.user_not_found")
  end
end
