module Api
  class V1::ScrumsController < ApplicationController

    def index
      render json: Scrum.all
    end

=begin
@api {get} /scrum Get todays scrum
@apiHeader (Authorization) {String} X-Auth-Token Astroscrum auth token
@apiDescription This will return all the details about your scrum
@apiSuccess (200 Response) {String} id A uuid for this resource
@apiSuccess (200 Response) {Date} date The date of the scrum (ISO 8601 format)
@apiSuccess (200 Response) {Integer} points the amount of points earned for this scrum
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
=end
    def show
      @scrum = current_team.current_scrum
      render json: @scrum
    end

  end
end
