module Api
  class V1::TasksController < ApplicationController

    def index
      render json: Task.all
    end

    def show
      @task = Task.find_by_id params[:id]
      render json: @task
    end

    def create
     puts "task_params ========================"
      puts task_params 

      @task = Task.new(task_params)

      if @task.save
        render json: @task
      else
        render json: { errors: []}
      end
    end

    private

    def task_params
      params.require(:task).permit(:user_id, :category, :body)
    end

  end
end
