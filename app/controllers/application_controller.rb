class ApplicationController < ActionController::API
  include ActionController::Serialization

  helper_method :current_player
  before_filter :authenticate!

  def authenticate!
    if token = params[:auth_token].blank? && request.headers['X-Auth-Token']
      params[:auth_token] = token
    end

    token = params[:auth_token].presence
    team = Team.find_by_auth_token(token)

    raise "Unable to authenticate request" unless team

    team
    # raise Exceptions::ApiAuthenticationError, "Unable to authenticate user" unless user
  end

  private

  def current_team
    authenticate!
    # @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end

  # def current_player
  #   @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  # end

end
