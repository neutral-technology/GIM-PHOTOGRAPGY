class AppsController < ApplicationController
    def index
    render layout: "default", :template => 'apps/index'
  end
end
