# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
# スレッド設定（空文字列対策）
max_threads_env = ENV.fetch("RAILS_MAX_THREADS", "5")
max_threads_count = max_threads_env.empty? ? 5 : Integer(max_threads_env)

min_threads_env = ENV.fetch("RAILS_MIN_THREADS", max_threads_count.to_s)
min_threads_count = min_threads_env.empty? ? max_threads_count : Integer(min_threads_env)

threads min_threads_count, max_threads_count

# 環境設定
rails_env = ENV.fetch("RAILS_ENV") { "development" }

# 本番環境でのワーカー設定
if rails_env == "production"
  worker_count_env = ENV.fetch("WEB_CONCURRENCY", "0")
  worker_count = worker_count_env.empty? ? 0 : Integer(worker_count_env)

  # ワーカーが2以上の場合のみクラスターモードを有効化
  if worker_count > 1
    workers worker_count
    preload_app!
  end
end

# 開発環境でのタイムアウト設定
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# ポート設定（空文字列対策）
port_env = ENV.fetch("PORT", "3000")
port port_env.empty? ? 3000 : Integer(port_env)

# 環境設定
environment rails_env

# PIDファイル
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# 再起動プラグイン
plugin :tmp_restart