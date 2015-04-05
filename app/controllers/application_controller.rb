class ApplicationController < ActionController::API
  include ActionController::Serialization

  helper_method :current_player

  private

  def current_player
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end

end
