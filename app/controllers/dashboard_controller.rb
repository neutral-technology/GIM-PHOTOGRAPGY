class DashboardController < ApplicationController
  def index
    render layout: "default", :template => 'dashboard/dashboard'
  end
  def analytics
    render layout: "default", :template => 'dashboard/analytics'
  end
  def finance
    render layout: "default", :template => 'dashboard/finance'
end
