class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  def update_resource(resource, params)
    return super if params['password'].present?

    resource.update_without_password(params.except('current_password'))
  end

  # 退会処理
  def destroy
    # 関連データの削除処理
    resource.items.destroy_all if resource.items.any?

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