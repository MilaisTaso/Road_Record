class Public::UsersController < ApplicationController
  before_action :user_verification, only: [:update,:withdrawal]
  before_action :authenticate_user!
  
  def show
    User.includes(:favorites);
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render 'show';
    end
  end

  def withdrawal
    current_user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :introduction, :user_image)
    end
    
    def user_verification
      user = User.find(params[id])
      if user != current_user
        redirect_to root_path, flash[:alert] = "編集権限がありません"
      end
    end
end
