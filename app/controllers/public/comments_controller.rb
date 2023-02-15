class Public::CommentsController < ApplicationController
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
end
