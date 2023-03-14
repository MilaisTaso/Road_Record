class Public::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_verification, only: [:edit, :update, :destroy]
  def new
    @course = Course.new
  end

  def index
    if params[:search].present?
      search_courses(params[:search])
      @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(8)
    elsif params[:sort].present?
      sort_courses(params[:sort])
    else
      @courses = Course.order(created_at: :desc).page(params[:page]).per(8)
    end
  end

  def show
    @course = Course.find(params[:id])
    impressionist(@course, nil, unique: [:ip_address]) # 追記
    @comment = Comment.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    #Courseレコードの保存処理
    @course = current_user.courses.new(course_params)
    #取得した距離を数字に直して、保存
    @course.distance = params[:course][:distance].to_f
    if @course.save
      add_address(@course, params[:course][:address])
      caputure_positions(params[:course][:latlng], @course)
      add_entities(@course, params[:course])
    end
    if @course.positions.present? && @course.addresses.present?
      redirect_to course_path(@course)
    else
      flash[:alert] = 'マップからコース情報を登録して下さい'
      render 'new'
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      @course.entities.destroy_all
      add_entities(@course, params[:course])
    end
    if @course.entities.present?
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
    
    #パラメータからアドレス情報を分解し、レコードへ保存
    def add_address(course, parameter)
      addresses = parameter.split(',')
      addresses.reverse_each do |address|
        address_data = course.addresses.new(
          name: address  
        )
        address_data.save
      end
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

    #Natural Lanuage APIを読み込みentityモデルのデータを作成
    def add_entities(course, parameter)
      response_data = Language.get_data(parameter[:introduction]).select{|data| data['type'] == "LOCATION" && data['metadata']['wikipedia_url'].present?}
      if response_data.present?
        response_data.each do |data|
          entity = course.entities.new(
            key_word: data['name']
          )
          entity.save
        end
      else
        course.addresses.each do |address|
          entity = course.entities.new(
            key_word: address.name
          )
          entity.save
        end
      end
    end

    #チェインメソッドで絞り込み検索を行う
    def search_courses(parameters)
      @courses = Course.all
      if parameters[:key_word].present?
        @courses = @courses.key_word_search(parameters[:key_word])
        search_address(parameters[:key_word])
        search_entities(parameters[:key_word])
        @courses += @address_courses if @address_courses.present?
        @courses += @entity_courses if @entity_courses.present?
        @courses = @courses.uniq
      end
      if parameters[:region].present?
        search_address(parameters[:region])
        @courses = @courses && @address_courses
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
    
    def search_address(parameter)
      @address_courses = []
      addresses = Address.region_about(parameter)
      addresses.each do |address|
        @address_courses << address.course
      end
    end
    
    def search_entities(parameter)
      @entity_courses = []
      entities = Entity.key_word_search(parameter)
      entities.each do |entity|
        @entity_courses << entity.course
      end
    end
    
    #条件に合わせてレコードのソートを行う
    def sort_courses(parameter)
      case parameter
        when '1'
          @courses = Course.order(created_at: :desc).page(params[:page]).per(8)
        when '2'
          @courses = Course.order(created_at: :asc).page(params[:page]).per(8)
        when '3'
          courses = Course.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
          @courses = Kaminari.paginate_array(courses).page(params[:page]).per(8)
        when '4'
          @courses = Course.order(impressions_count: 'DESC').page(params[:page]).per(8)
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
