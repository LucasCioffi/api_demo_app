class Api::GameEventsController < ApplicationController
  before_action :authenticate_user

  def create
    if params[:game_event][:game_id].blank? || params[:game_event][:occurred_at].blank? || params[:game_event][:type] != 'COMPLETED'
      head(:unprocessable_entity)
      return
    end

    GameEvent.create(
      user_id: current_user.id,
      game_id: params[:game_event][:game_id],
      occurred_at: params[:game_event][:occurred_at]
    )

    current_user.total_games_played += 1
    current_user.save

    head(:created)
  end
end