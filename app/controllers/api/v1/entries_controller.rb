module Api
  class V1::EntriesController < ApplicationController

    def index
      render json: Entry.all
    end

    def show
      @entry = Entry.find_by_id params[:id]
      render json: @entry
    end

    def create
      @entry = Entry.new(entry_params)

      if @entry.save
        render json: @entry
      else
        render json: { errors: []}
      end
    end

    private

    def entry_params
      params.require(:entry).permit(:category, :body)
    end

  end
end
