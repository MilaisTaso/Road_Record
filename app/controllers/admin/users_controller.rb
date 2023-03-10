class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @courses = @user.courses.page(params[:page]).per(5)
    @followed = @user.following.page(params[:page]).per(5)
    @followers = @user.followers.page(params[:page]).per(5)
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end

  def withdrawal
    user = User.find(params[:user_id])
    if user.is_deleted
      user.update(is_deleted: false)
      flash[:notice] = "会員を有効にしました"
    else
      user.update(is_deleted: true)
      flash[:notice] = "会員を退会にしました"
    end
      redirect_to admin_user_path(user)
  end
end
