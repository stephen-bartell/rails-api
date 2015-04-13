module Api
  class V1::PlayersController < ApplicationController

    def index
      render json: Player.all
    end

    def show
      @player = Player.find_by_id params[:id]
      render json: @player
    end

    def create
      puts "player_params ========================"
      puts player_params 

      @player = Player.new(player_params)

      if @player.save
        render json: @player
      else
        render json: { errors: []}
      end
    end

    private

    def player_params
      params.require(:player).permit(:email, :password)
    end

  end
end
