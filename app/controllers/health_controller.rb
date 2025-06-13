class HealthController < ApplicationController
  skip_before_action :authenticate_user!
  
  def check
    render plain: "OK - App is running!"
  end
end