module Api
  class V1::SessionsController < ApplicationController
    
    def create
      player = Player.authenticate(params[:email], params[:password])
      if player
        session[:player_id] = player.id
        render json: { message: "logged in" }
      else
        render json: { message: "Invalid email or password" }
      end
    end

    def destroy
      session[:player_id] = nil
      render json: { message: "Logged out!" }
    end

  end
end
