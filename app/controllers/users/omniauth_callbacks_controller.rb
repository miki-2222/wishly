class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
    end
    sign_in_and_redirect @user, event: :authentication
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    Rails.logger.error e.message
    redirect_to new_user_session_path, alert: 'Googleログインに失敗しました'
  end

  def failure
    redirect_to root_path, alert: 'Google 認証に失敗しました'
  end
end
