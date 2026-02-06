class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  # 関連データも一緒に削除
  has_many :items, dependent: :destroy
  has_many :auths, dependent: :destroy

  accepts_nested_attributes_for :auths

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true

  # 一意の文字列を生成するメソッド
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.from_omniauth(auth)
    # 既存の OAuth 紐付けがあれば即返す
    ActiveRecord::Base.transaction do
      auth_record = Auth.find_by(
        provider: auth.provider,
        uid: auth.uid
      )
      return auth_record.user if auth_record
    end

    # ② email で既存ユーザー検索
    user = User.find_by(email: auth.info.email)

    if user
      # ③ 既存ユーザーに OAuth を追加
      user.auths.create!(
        provider: auth.provider,
        uid: auth.uid
      )
      return user
    end

    # ④ 完全新規ユーザー
    User.create!(
      email: auth.info.email,
      name: auth.info.name || 'No Name',
      password: Devise.friendly_token[0, 20],
      auths_attributes: [{
        provider: auth.provider,
        uid: auth.uid
      }]
    )
  end
end