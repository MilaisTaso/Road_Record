class Public::CoursesController < ApplicationController
  def new
    @course = Course.new
  end

  def index
    @courses = Course.all
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
    course = current_user.courses.new(course_params)
    #取得したアドレスを配列にした後、反転・結合して正規住所にし、保存
    address = params[:course][:address].split(',')
    course.address = address.reverse.join('')
    #取得した距離を数字に直して、保存
    course.distance = params[:course][:distance].to_f
    if course.save
      caputure_positions(params[:course][:latlng], course)
      redirect_to courses_path
    else
      render 'new'
    end
  end

  def update
    course = Course.find(params[:id])
    if course.update(course_params)
      redirect_to courses_path
    else
      render 'index'
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
      params.require(:course).permit(:title, :introduction, :suggest_time,
        :signal_condition, :traffic_volume, :is_slope, course_images:[])
    end

    def caputure_positions(parameter, course)
      positions = parameter.split("|")
      positions.each do |position|
        lat_lng = position.split(",")
        position_data = course.positions.new(
          lat: lat_lng[1],
          lng: lat_lng[0]
        )
        unless position_data.save
          render 'new'
        end
      end
    end
end
