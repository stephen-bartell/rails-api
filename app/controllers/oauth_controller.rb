class OauthController < ApplicationController

  skip_before_action :authenticate!

  def join
    redirect_to "https://slack.com/oauth/authorize?client_id=#{ENV["SLACK_API_CLIENT_ID"]}&scope=admin"
  end

  def callback
    response = RestClient.post "https://slack.com/api/oauth.access", code: params[:code], client_id: ENV["SLACK_API_CLIENT_ID"], client_secret: ENV["SLACK_API_CLIENT_SECRET"]

    puts "====================================================="
    puts JSON.parse(response)
    puts "====================================================="

  end

end
