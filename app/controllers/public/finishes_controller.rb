class Public::FinishesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    finish = current_user.finishes.new(course_id: @course.id)
    finish.save
    if @course.favorited_by?(current_user)
      favorite = @course.favorites.find_by(user_id:current_user.id)
      favorite.destroy
    end
    render 'public/favorites/create'
  end

  def destroy
    @course = Course.find(params[:course_id])
    finish = current_user.finishes.find_by(course_id: @course.id)
    finish.destroy
    render 'public/favorites/create'
  end
end
