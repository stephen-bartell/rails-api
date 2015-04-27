class ApplicationController < ActionController::API
  include ActionController::Serialization

  helper_method :current_team
  before_action :authenticate!

  def auth_token
    if token = params[:auth_token].blank? && request.headers['X-Auth-Token']
      params[:auth_token] = token
    end

    token = params[:auth_token].presence
  end

  def authenticate!
    team = Team.find_by_auth_token(auth_token)
    team || head(:unauthorized)
  end

  private

  def current_team
    authenticate!
  end

end
