class ProfileController < ApplicationController
  before_action :set_user, only: [:show]
  
  def show; end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    return if @user
     
    redirect_to root_path, alert: t("msg.user_not_found")
  end
end
