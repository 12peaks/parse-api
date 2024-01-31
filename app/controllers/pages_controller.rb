class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]

  def index
    redirect_to dashboard_path
  end

  def dashboard
  end
end
