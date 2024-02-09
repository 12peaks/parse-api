class Api::TeamsController < ApplicationController
  include ApiAuthentication
  skip_forgery_protection
  before_action :authenticate_user!, unless: -> { api_user.present? }

  private
end