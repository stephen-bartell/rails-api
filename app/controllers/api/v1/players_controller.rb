module Api
  class V1::PlayersController < ApplicationController

=begin
@api {get} /players Get all players
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return an array of the players on your team. You can only see players that are on your team (in the same account)
@apiSuccess (200 Response) {Array} players An array of player resources
@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "players": [
    {
      "email": "jpsilvashy@gmail.com",
      "id": "ac91ae0f-ce75-4d62-b7ae-3a03b187b54e",
      "name": "jpsilvashy",
      "points": 0,
      "real_name": "JP Silvashy",
      "slack_id": "U0480481U"
    },
    {
      "email": "neckbeard@example.com",
      "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
      "name": "neckbeard",
      "points": 0,
      "real_name": "Neck Beard",
      "slack_id": "U0485M91U"
    }
  ]
}

@apiName GetPlayers
@apiGroup Player
=end
    def index
      render json: current_team.players.all
    end

=begin
@api {get} /players/:id Get a player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return a specific player on your team. You can only see players that are on your team (in the same account)
@apiSuccess (200 Response) {String} id A uuid for this resource
@apiSuccess (200 Response) {String} slack_id The `slack_id` for this player (a uuid for slack)
@apiSuccess (200 Response) {String} name The players chat mention name and shortname
@apiSuccess (200 Response) {String} real_name The full name for this player
@apiSuccess (200 Response) {String} email The players email address
@apiSuccess (200 Response) {Integer} points The total point earnings for this player for the current season
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

@apiName GetPlayer
@apiGroup Player
@apiParam {String} id String unique ID.
=end
    def show
      @player = current_team.players.find_by_id params[:id]
      @player = current_team.players.find_by_slack_id params[:id] unless @player

      render json: @player
    end

=begin
@api {post} /players Create a player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiParam {String} password Password
@apiParam {String} name Short name or chat mention name
@apiParam {String} email Email address for player
@apiParam {String} [slack_id] Optional the `slack_id` of the user, **required** if using Astroscrum Hubot client
@apiParam {String} [real_name] Optional real name of the Player

@apiSuccess (200 Response) {String} id A uuid for this resource
@apiSuccess (200 Response) {String} slack_id The `slack_id` for this player (a uuid for slack)
@apiSuccess (200 Response) {String} name The players chat mention name and shortname
@apiSuccess (200 Response) {String} real_name The full name for this player
@apiSuccess (200 Response) {String} email The players email address
@apiSuccess (200 Response) {Integer} points The total point earnings for this player for the current season
@apiErrorExample {json} Error-Response:
HTTP/1.1 200 OK
{
  "errors": {
    "email": [
      "can't be blank"
    ],
    "password": [
      "can't be blank"
    ]
  }
}

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

@apiName CreatePlayer
@apiGroup Player
=end
    def create
      @player = Player.where(slack_id: player_params[:slack_id], team_id: current_team.id).first_or_initialize
      @player.attributes = player_params

      if @player.save
        render json: @player
      else
        render json: { errors: @player.errors.messages }
      end
    end


=begin
@api {put} /players/:id Update a player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiParam {String} password Password
@apiParam {String} name Short name or chat mention name
@apiParam {String} email Email address for player
@apiParam {boolean} player receives notifications?
@apiParam {String} [real_name] Optional real name of the Player

@apiSuccess (200 Response) {String} id A uuid for this resource
@apiSuccess (200 Response) {String} slack_id The `slack_id` for this player (a uuid for slack)
@apiSuccess (200 Response) {String} name The players chat mention name and shortname
@apiSuccess (200 Response) {String} real_name The full name for this player
@apiSuccess (200 Response) {boolean} the player will receive email and chat notifications
@apiSuccess (200 Response) {String} email The players email address
@apiSuccess (200 Response) {Integer} points The total point earnings for this player for the current season
@apiErrorExample {json} Error-Response:
HTTP/1.1 200 OK
{
  "errors": {
    "email": [
      "can't be blank"
    ],
    "password": [
      "can't be blank"
    ]
  }
}

@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "player": {
    "email": "neckbeard@example.com",
    "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
    "name": "neckbeard",
    "points": 0,
    "real_name": "Neck Beard",
    "slack_id": "U0485M91U",
    "notifications": true
  }
}

@apiName UpdatePlayer
@apiGroup Player
=end
    def update
      @player = Player.where(id: params[:id], team_id: current_team.id).first
      @player.attributes = update_params

      if @player.save
        render json: @player
      else
        render json: { errors: @player.errors.messages }
      end
    end

    private

    def player_params
      params.require(:player).permit(:email, :slack_id, :name, :real_name, :password)
    end

    def update_params
      params.require(:player).permit(:email, :name, :real_name, :password, :notifications)
    end

  end
end

