class Admin::CoursesController < ApplicationController
  before_action :authenticate_admin!
  def index
    @courses = Course.page(params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end
  
  def destroy
    Course.find(params[:id]).destroy
    redirect_to admin_courses_path
  end
end
