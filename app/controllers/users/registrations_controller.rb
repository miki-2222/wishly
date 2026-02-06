class Users::RegistrationsController < Devise::RegistrationsController

  def update_resource(resource, params)
    if params['password'].present?
      # パスワードを更新する場合は通常の更新処理
      super
    else
      # パスワードを更新しない場合は、パスワードなしで更新
      resource.update_without_password(params.except('current_password'))
    end
  end

  # 退会処理
  def destroy

    # ユーザー自体を物理削除
    resource.destroy

    # ログアウト処理
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    # フラッシュメッセージ
    set_flash_message! :notice, :destroyed

    # リダイレクト
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end
end