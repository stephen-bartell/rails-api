module Api
  class V1::ScrumsController < ApplicationController

    def index
      render json: Scrum.all
    end

    def show
    end

  end
end
