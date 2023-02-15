class ApplicationController < ActionController::Base
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
end
