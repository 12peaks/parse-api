class Api::PollOptionsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection
end
