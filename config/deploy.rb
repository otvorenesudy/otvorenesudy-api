# frozen_string_literal: true

# Deployed by a maintainer with `bundle exec cap production deploy`, from main.
lock '~> 3.20'

set :application, 'otvorenesudy-api'
# The github.com-otvorenesudy-api SSH host alias picks the deploy key; from your own machine, use github.com.
set :repo_url, 'git@github.com-otvorenesudy-api:otvorenesudy/otvorenesudy-api.git'

set :user, 'deploy'
set :ssh_options, { forward_agent: true }

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# The server's own dotenv file, with the production settings, which git ignores, and the production credentials' key.
set :linked_files, fetch(:linked_files, []).push('.env', 'config/credentials/production.key')
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/downloads', 'tmp/extracted', 'vendor/bundle'
)

set :keep_releases, 2

set :whenever_identifier, -> { "#{fetch(:application)}-#{fetch(:stage)}" }

# One Sidekiq service, under the name the server already runs it by, with the deploy user's settings and the app's.
set :sidekiq_config_files, ['sidekiq.yml']
set :sidekiq_service_unit_name, "#{fetch(:application)}.sidekiq"
set :sidekiq_service_unit_user, :user
set :sidekiq_service_unit_env_files, -> { ["/home/#{fetch(:user)}/.env", "#{current_path}/.env"] }

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'

  desc 'Deploy to a new server: create and load the databases instead of migrating them'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'sidekiq:install'
    invoke 'deploy:prepare_database'
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Create the databases and load their structure, or migrate existing ones'
  task :prepare_database do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) || fetch(:stage) do
          execute :rake, 'db:prepare'
        end
      end
    end
  end
end
