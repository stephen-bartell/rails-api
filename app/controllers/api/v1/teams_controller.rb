module Api
  class V1::TeamsController < ApplicationController

    def index
      render json: Team.all
    end

    def create
      @team = Team.new(team_params)

      if @team.save
        render json: @team
      else
        render json: { errors: []}
      end
    end

    private

    def team_params
      params.require(:team).permit(:slack_id, :name)
    end

  end
end
