class ApplicationController < ActionController::Base
  before_action :set_csrf_cookie
  before_action :redirect_if_signed_in

  private
  
  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = form_authenticity_token
  end

  def redirect_if_signed_in
    return unless request.format.html?

    if user_signed_in?
      redirect_to ENV["CLIENT_URL"], allow_other_host: true
    end
  end
end
