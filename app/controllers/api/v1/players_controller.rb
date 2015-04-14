module Api
  class V1::PlayersController < ApplicationController

=begin
@api {get} /players Get all players
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token.
@apiDescription This will return an array of the players on your team. You can only see players that are on your team (in the same account).
@apiSuccess (200) {String} id A uuid for this resource.
@apiSuccess (200) {String} name The players chat mention name and shortname.
@apiSuccess (200) {String} real_name The full name for this player.
@apiSuccess (200) {String} email The players email address.
@apiSuccess (200) {Integer} points The total point earnings for this player for the current season.
@apiSuccessExample {json} Success-Response:
  HTTP/1.1 200 OK
  {
    "players": [
      {
        "email": "jpsilvashy@gmail.com",
        "id": "21c246df-334a-43ab-9e00-a2084c656b41"
      },
      {
        "email": "neckbeard@example.com",
        "id": "a2e6a081-3538-479f-bd4c-e04c7d682953"
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
@api {get} /players/:id Get a specific player
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token.
@apiDescription This will return a specific player on your team. You can only see players that are on your team (in the same account).
@apiSuccess (200) {String} id A uuid for this resource.
@apiSuccess (200) {String} name The players chat mention name and shortname.
@apiSuccess (200) {String} real_name The full name for this player.
@apiSuccess (200) {String} email The players email address.
@apiSuccess (200) {Integer} points The total point earnings for this player for the current season.
@apiSuccessExample {json} Success-Response:
  HTTP/1.1 200 OK
  {
    "player": {
      "id": "070df1c9-51d9-4bd6-8e38-2cae0428e553",
      "name": "jpsilvashy",
      "real_name": "JP Silvashy",
      "email": "jpsilvashy@gmail.com",
      "points": 210
    }
  }
@apiName GetPlayers
@apiGroup Player
@apiParam {String} id String unique ID.
=end
    def show
      @player = Player.find_by_id params[:id]
      render json: @player
    end

=begin
@api {post} /players Create a player
@apiName CreatePlayer
@apiGroup Player
=end
    def create
      @player = Player.new(player_params)

      if @player.save
        render json: @player
      else
        render json: { errors: []}
      end
    end

    private

    def player_params
      params.require(:player).permit(:email, :mention_name, :real_name, :password)
    end

  end
end
