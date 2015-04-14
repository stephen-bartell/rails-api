module Api
  class V1::ScrumsController < ApplicationController

    def index
      render json: Scrum.all
    end

    def show
      @scrum = Scrum.find_by_id params[:id]
      render json: @scrum
    end

  end
end
