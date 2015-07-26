module Api
  class V1::SlackController < ApplicationController

=begin
@api {post} /slack/join Create a player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token

@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "player": {
    "email": "neckbeard@example.com",
    "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
    "name": "neckbeard",
    "points": 0,
    "real_name": "Neck Beard",
    "slack_id": "U0485M91U"
  }
}

@apiName SlackJoin
@apiGroup Slack
=end
    def join
      puts "params +++++++++++++++++++++++++++++++++++++++"
      puts params

      @player = Player.where(slack_id: player_params[:slack_id], team_id: current_team.id).first_or_initialize
      @player.first_or_initialize_from_slack_user(slack_user_params)

      if @player.save
        render json: @player
      else
        render json: { errors: @player.errors.messages }
      end
    end

    private

    def slack_user_params
      params.require(:player).permit!
    end

  end
end

