Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # ルートパスをitems一覧に設定
  root "items#index"

  # アイテムのCRUD操作
  resources :items do
    resources :items
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # ヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check
end