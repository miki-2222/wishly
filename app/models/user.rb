class User < ApplicationRecord
  has_many :items, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 関連データも一緒に削除
  has_many :items, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true

end