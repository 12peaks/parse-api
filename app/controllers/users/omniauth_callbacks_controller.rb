class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"], cookies[:referral])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    cookies.signed[:user] = { value: @user.id, expires: 1.year.from_now, httponly: true }
  end

  def failure
    redirect_to root_path
  end
end