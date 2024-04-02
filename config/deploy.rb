lock '3.18.1'

# Repository
set :application, 'otvorenesudy-api'
set :repo_url, 'git@github.com:otvorenesudy/otvorenesudy-api.git'

# Sidekiq
set :sidekiq_processes, 1
set :sidekiq_service_unit_name, "#{fetch(:application)}.sidekiq"

# Rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Whenever
set :whenever_identifier, -> { "#{fetch(:application)}-#{fetch(:stage)}" }

# Links
set :linked_files, fetch(:linked_files, []).push('.env', 'config/credentials/production.key')
set :linked_dirs,
    fetch(:linked_dirs, []).push(
      'log',
      'node_modules',
      'public/packs',
      'tmp/pids',
      'tmp/cache',
      'tmp/sockets',
      'tmp/downloads',
      'vendor/bundle',
      'tmp/extracted'
    )

set :keep_releases, 2
set :ssh_options, { forward_agent: true }

namespace :deploy do
  before 'deploy:assets:precompile', 'deploy:yarn'
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'

  desc 'Deploy app for first time'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'sidekiq:install'
    invoke 'deploy:database' # This replaces deploy:migrations
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Setup database'
  task :database do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:create'
          execute :rake, 'db:migrate'
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Run rake yarn install'
  task :yarn do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
