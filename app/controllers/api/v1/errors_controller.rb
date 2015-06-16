module Api
  class V1::ErrorsController < ApplicationController

    skip_filter :authenticate!, only: [ :create ]

    def exception
      render :json => { :error => "internal-server-error" }.to_json, :status => 500
    end

  end
end
