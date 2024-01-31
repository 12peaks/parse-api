class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"], cookies[:referral])
    if @user.persisted?
      sign_in(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
      cookies.signed[:user] = { value: @user.id, expires: 1.year.from_now, httponly: true }

      redirect_to ENV["CLIENT_URL"], allow_other_host: true
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end