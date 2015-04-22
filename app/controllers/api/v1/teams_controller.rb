module Api
  class V1::TeamsController < ApplicationController

    skip_filter :authenticate!, only: [ :create ]

=begin
@api {get} /team Get your team
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return all the details about your team
@apiSuccess (200 Response) {String} id A uuid for this resource
@apiSuccess (200 Response) {String} slack_id The `slack_id` for this team (a uuid for slack)
@apiSuccess (200 Response) {String} name The team name in Slack
@apiSuccess (200 Response) {Integer} points The total point earnings for this team for the current season
@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "team": {
    "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
    "name": "companyname",
    "points": 0,
    "slack_id": "U0485M91U"
  }
}
@apiName GetTeam
@apiGroup Team
=end
    def show
      puts current_team.to_json
      render json: current_team
    end

=begin
@api {post} /teams Create a team
@apiSuccess (200 Response) {String} auth_token The `auth_token`, you'll be required to send with all other requests
@apiParam {String} name The team name in Slack
@apiParam {String} slack_id The `slack_id` of the team
@apiExample {json} Example-Request:
POST /v1/team HTTP/1.1
{
  "team": {
     "name": "Astroscrum"
  }
}

@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "team": {
    "auth_token": "c25a1f20b3af295280024c991a205482",
  }
}

@apiName CreateTeam
@apiGroup Team
=end
    def create
      @team = Team.where(slack_id: team_params[:slack_id]).first_or_initialize
      @team.attributes = team_params

      if @team.save
        render json: {
          team: {
            auth_token: @team.auth_token,
            id: @team.id,
            name: @team.name,
            points: @team.points,
            slack_id: @team.slack_id
          }
        }
      else
        render json: { errors: @team.errors.messages }
      end
    end

    private

    def team_params
      params.require(:team).permit(:slack_id, :name, :bot_url, :prompt_at, :remind_at, :summary_at, :timezone)
    end

  end
end
