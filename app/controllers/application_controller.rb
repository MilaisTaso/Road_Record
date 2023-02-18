class ApplicationController < ActionController::Base
  #例外処理発生時の対応
  rescue_from StandardError, with: :rescue500
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  
  before_action :authenticate_user!, except: [:top]
  before_action :devise_permitted_parameters, if: :devise_controller?

  private
    #deviseで追加で受け取るカラム
    def devise_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # ログイン・ログアウト後の遷移先設定
    def after_sign_in_path_for(resource)
      root_path
    end

    def after_sign_out_path_for(resource)
      new_user_session_path
    end
    
    def rescue404(e)
      render "errors/not_found", status: 404
    end
    
    def rescue500(e)
      render "errors/internal_server_error", status: 500
    end
end
