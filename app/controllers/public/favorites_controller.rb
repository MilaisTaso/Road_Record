class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @course = Course.find(params[:course_id])
    favorite = current_user.favorites.new(course_id: @course.id)
    favorite.save
    if @course.finished_by?(current_user)
      finish = @course.finishes.find_by(user_id:current_user.id)
      finish.destroy
    end
    @favorites = current_user.favorites.page(params[:page]).per(4)
  end

  def destroy
    @course = Course.find(params[:course_id])
    favorite = current_user.favorites.find_by(course_id: @course.id)
    favorite.destroy
    @favorites = current_user.favorites.page(params[:page]).per(4)
    render 'public/favorites/create'
  end
end
