class ApplicationController < ActionController::Base
  #例外処理発生時の対応
  # rescue_from StandardError, with: :rescue500
  # rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  private
    # def rescue404(e)
    #   render "errors/not_found", status: 404
    # end
    
    # def rescue500(e)
    #   render "errors/internal_server_error", status: 500
    # end
end
