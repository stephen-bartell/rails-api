module Api
  class V1::ScrumsController < ApplicationController

    def index
      render json: Scrum.all
    end

=begin
@api {get} /scrum Get todays scrum
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return all the details about your scrum
@apiSuccess (Response) {String} id A uuid for this resource
@apiSuccess (Response) {Date} date The date of the scrum (ISO 8601 format)
@apiSuccess (Response) {String} name The scrum name in Slack
@apiSuccessExample {json} Success-Response:
  HTTP/1.1 200 OK
  {
    "scrum": {
      "id": "ecb72023-12ae-4f98-8996-326df9b8b2c7",
      "date": "2015-04-12",
      "points": 0
    }
  }
@apiName GetScrum
@apiGroup Scrum
@apiParam {String} id String unique ID
=end
    def show
      @scrum = Scrum.find_by_id params[:id]
      render json: @scrum
    end

  end
end
