class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]
  
  def index
    redirect_to ENV["CLIENT_URL"], allow_other_host: true
  end

  def dashboard
  end
end
