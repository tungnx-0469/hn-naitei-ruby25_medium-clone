class ProfileController < ApplicationController
  before_action :set_user, only: [:show]
  
  def show
    @article = Article.new
  end

  private
  def set_user
    @user = User.includes(:articles).find_by(id: params[:id])
    return if @user
     
    redirect_to root_path, alert: t("msg.user_not_found")
  end
end
