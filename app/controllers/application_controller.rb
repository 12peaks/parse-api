class ApplicationController < ActionController::Base
  before_action :set_csrf_cookie

  def after_sign_in_path_for(user)
    ENV["CLIENT_URL"]
  end

  private
  
  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = form_authenticity_token
  end
end
