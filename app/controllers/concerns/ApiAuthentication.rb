module ApiAuthentication
  extend ActiveSupport::Concern
  included do
    before_action :authenticate
  end

  def api_user
    @api_key.user if @api_key
  end

  private

  def api_request?
    request.headers["Authorization"].present?
  end

  def authenticate
    authenticate_token || unauthenticated if api_request?
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      @api_key = ApiKey.find_by(key: token)
    end
  end

  def unauthenticated
    render json: { error: "Invalid API key" }, status: :unauthorized
  end
end
