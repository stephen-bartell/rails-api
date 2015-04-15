class ApplicationController < ActionController::API
  include ActionController::Serialization

  helper_method :current_player

  def authenticate_user_from_token!
    if token = params[:auth_token].blank? && request.headers['X-Auth-Token']
      params[:auth_token] = token
    end

    token = params[:auth_token].presence
    player = Player.find_by_auth_token(token)

    # raise Exceptions::ApiAuthenticationError, "Unable to authenticate user" unless user
  end

  private

  def current_player
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end

  # def current_player
  #   @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  # end

end
