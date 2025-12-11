# --- ビルドステージ ---
FROM ruby:3.2.2-slim AS build

# 作業ディレクトリを設定
WORKDIR /rails

# 必要なパッケージをインストール(curlを追加!)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Node.jsのインストール（package.jsonがある場合に備えて）
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Gemfileをコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# package.jsonがある場合のみNode modulesをインストール
# ファイルが存在しない場合はスキップ
COPY --chown=rails:rails . .
RUN if [ -f package.json ]; then \
      if [ -f yarn.lock ]; then \
        yarn install --frozen-lockfile; \
      else \
        npm install; \
      fi \
    fi

# アセットをプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# --- 実行ステージ ---
FROM ruby:3.2.2-slim

# 作業ディレクトリを設定
WORKDIR /rails

# 実行に必要なパッケージのみインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# railsユーザーを作成
RUN useradd rails --create-home --shell /bin/bash

# ビルドステージから成果物をコピー
COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

# エントリーポイントスクリプトに実行権限を付与
RUN chmod +x /rails/bin/docker-entrypoint

# railsユーザーに切り替え
USER rails:rails

# 環境変数を設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_SERVE_STATIC_FILES="true"

# エントリーポイントを設定
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# デフォルトコマンド
CMD ["./bin/rails", "server"]