module Api
  class V1::PlayersController < ApplicationController

    def index
      render json: Player.all
    end

    def show
      @player = Player.find_by_id params[:id]
      render json: @player
    end

  end
end
