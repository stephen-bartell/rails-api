module Api
  class V1::EntriesController < ApplicationController

=begin
@api {post} /entries Create a scrum entry
@apiParam {String} category
@apiParam {String} body
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiSuccess (Response) {String} id A uuid for this resource
@apiSuccess (Response) {String} category Category for scrum key, e.g. today, yesterday, or blocker
@apiSuccess (Response) {String} body The task related to the category
@apiSuccess (Response) {Points} points How many points earned by the Player for this task
@apiSuccessExample {json} Success-Response:
HTTP/1.1 200 OK
{
  "entry": {
    "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
    "category": "today",
    "body": "I'm working on payment processing",
    "points": 5
  }
}

@apiName CreateEntry
@apiGroup Entry
=end
    def create
      player = current_team.players.find_by_slack_id(entry_params[:slack_id])

      entry = {
        scrum_id: current_team.current_scrum.id,
        player_id: player.id,
        category: entry_params[:category],
        body: entry_params[:body]
      }

      @entry = Entry.new(entry)

      if @entry.save
        render json: @entry
      else
        render json: { errors: @entry.errors.messages }
      end
    end

    private

    def entry_params
      params.require(:entry).permit(:slack_id, :category, :body)
    end

  end
end
