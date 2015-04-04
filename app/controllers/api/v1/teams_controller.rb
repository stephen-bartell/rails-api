module Api
  class V1::TeamsController < ApplicationController

    def index
      render json: Team.all
    end

    def show
    end

  end
end
