module Api
  class V1::PlayersController < ApplicationController

=begin
@api {get} /players Get all players
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return an array of the players on your team. You can only see players that are on your team (in the same account)
@apiSuccess (Response) {String} id A uuid for this resource
@apiSuccess (Response) {String} name The players chat mention name and shortname
@apiSuccess (Response) {String} real_name The full name for this player
@apiSuccess (Response) {String} email The players email address
@apiSuccess (Response) {String} slack_id The unique `slack_id` for the player
@apiSuccess (Response) {Integer} points The total point earnings for this player for the current season
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
      render json: Player.all
    end

=begin
@api {get} /players/:id Get a player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return a specific player on your team. You can only see players that are on your team (in the same account)
@apiSuccess (Response) {String} id A uuid for this resource
@apiSuccess (Response) {String} slack_id The `slack_id` for this player (a uuid for slack)
@apiSuccess (Response) {String} name The players chat mention name and shortname
@apiSuccess (Response) {String} real_name The full name for this player
@apiSuccess (Response) {String} email The players email address
@apiSuccess (Response) {Integer} points The total point earnings for this player for the current season
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
      @player = Player.find_by_id params[:id]
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
      @player = Player.new(player_params)

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

  end
end

