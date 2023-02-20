class Public::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :user_verification, only: [:destroy]
  
  
  def create
    @course = Course.find(params[:course_id])
    @comment = current_user.comments.new(comment_params)
    @comment.course_id = @course.id
    if @comment.save
    redirect_to course_path(@course.id)
    else
      render 'public/courses/show'
    end
  end

  def destroy
    Comment.find_by(id: params[:id], course_id: params[:course_id]).destroy
    redirect_to request.referer
  end

  private
    def comment_params
      params.require(:comment).permit(:comment)
    end
    
    def user_verification
      return if admin_signed_in?
      comment = Comment.find_by(id: params[:id], course_id: params[:course_id])
      if comment.user != current_user
        redirect_to root_path, flash[:alert] = "編集権限がありません"
      end
    end
end
