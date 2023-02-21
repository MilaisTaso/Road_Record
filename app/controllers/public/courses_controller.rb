class Public::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_verification, only: [:edit, :update, :destroy]
  def new
    @course = Course.new
  end

  def index
    if params[:search].present?
      search_courses(params[:search])
    else
      @courses = Course.all.page(params[:page]).per(8)
    end
  end

  def show
    @course = Course.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    #Courseレコードの保存処理
    @course = current_user.courses.new(course_params)
    #取得したアドレスを配列にした後、反転・結合して正規住所にし、保存
    address = params[:course][:address].split(',')
    @course.address = address.reverse.join('')
    #取得した距離を数字に直して、保存
    @course.distance = params[:course][:distance].to_f
    if @course.save
      caputure_positions(params[:course][:latlng], @course)
    end
    if @course.positions.present?
      redirect_to course_path(@course)
    else
      flash[:alert] = 'マップからコース情報を登録して下さい'
      render 'new'
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      redirect_to course_path(@course)
    else
      render 'edit'
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    redirect_to courses_path
  end

  private
    #ストロングパラメータ
    def course_params
      params.require(:course).permit(:title, :introduction, :suggest_time,:signal_condition,
      :traffic_volume, :is_slope, :distance, course_images:[])
    end

    #コースパラメータからポジションテーブルのレコードを作成する
    def caputure_positions(parameter, course)
      if parameter.present?
        positions = parameter.split("|")
        positions.each do |position|
          lat_lng = position.split(",")
          position_data = course.positions.new(
            lat: lat_lng[1],
            lng: lat_lng[0]
          )
          position_data.save
        end
      end
    end
    
    #チェインメソッドで絞り込み検索を行う
    def search_courses(parameters)
      @courses = Course.all
      if parameters[:key_word].present?
        @courses = @courses.key_word_search(parameters[:key_word])
      end
      if parameters[:region].present?
        @courses = @courses.region_about(parameters[:region])
      end
      if parameters[:suggest_time].present?
        @courses = @courses.where(suggest_time: parameters[:suggest_time])
      end
      if parameters[:signal_condition].present?
        @courses = @courses.where(signal_condition: parameters[:signal_condition])
      end
      if parameters[:traffic_volume].present?
        @courses = @courses.where(traffic_volume: parameters[:traffic_volume])
      end
      if parameters[:is_slope].present?
        @courses = @courses.where(is_slope: parameters[:is_slope])
      end
    end
    
    def user_verification
      return if admin_signed_in?
      course = Course.find(params[:id])
      if course.user != current_user
        redirect_to root_path, flash[:alert] = "編集権限がありません"
      end
    end
end
