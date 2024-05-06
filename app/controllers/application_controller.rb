class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none

  def authenticate_user
    if !current_user
      head(:unauthorized)
      return
    end
  end
end
