# ベースイメージ
FROM ruby:3.2.3-slim

# 作業ディレクトリを設定
WORKDIR /rails

# 環境変数を設定
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true"

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    postgresql-client \
    pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Node.jsとYarnのインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Bundlerのインストール（最新の安定版）
RUN gem update --system && \
    gem install bundler

# Gemfileをコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle clean --force && \
    rm -rf /usr/local/bundle/cache/*.gem

# アプリケーションのコードをすべてコピー
COPY . .

# package.jsonがある場合のみNode modulesをインストール
RUN if [ -f package.json ]; then \
      if [ -f yarn.lock ]; then \
        yarn install --frozen-lockfile; \
      else \
        npm ci; \
      fi \
    fi

# アセットをプリコンパイル
# 注意: RAILS_MASTER_KEYは環境変数として渡す必要があります
RUN if [ -n "$RAILS_MASTER_KEY" ]; then \
      bundle exec rails assets:precompile; \
    else \
      echo "Warning: RAILS_MASTER_KEY not set, skipping asset precompilation"; \
    fi

# 不要なファイルを削除してイメージサイズを削減
RUN rm -rf node_modules tmp/cache vendor/bundle/ruby/*/cache

# 非rootユーザーを作成（セキュリティ向上）
RUN useradd -m -u 1000 rails && \
    chown -R rails:rails /rails
USER rails

# ポートを公開
EXPOSE 3000

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/up || exit 1

# 起動コマンド（マイグレーションは別途実行）
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]