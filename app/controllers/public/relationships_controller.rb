class Public::RelationshipsController < ApplicationController
  
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(4)
  end

  def destroy
    current_user.unfollow(params[:user_id])
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(4)
    render 'create'
  end
end
