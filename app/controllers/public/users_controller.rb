class Public::UsersController < ApplicationController
  
  def show
    User.includes(:favorites);
    @user = User.find(params[:id])
  end

  def edit

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

  def user_params
    params.require(:user).permit(:name, :introduction, :user_image)
  end
end
