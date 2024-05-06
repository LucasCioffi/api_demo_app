class Api::SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      render json: { user: user.as_json(only: [:email, :authentication_token]) }, status: :created
    else
      head(:unauthorized)
    end
  end

end