# config valid only for current version of Capistrano
lock '3.4.0'

# Repository
set :application, 'opencourts-api'
set :scm,         :git
set :repo_url,    'git@github.com:otvorenesudy/otvorenesudy-api.git'

# RVM
set :rvm_type,         :user
set :rvm_ruby_version, '2.2.2'

# Links
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs,  fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')

set :keep_releases, 5
set :ssh_options, {
  forward_agent: true
}

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'

  desc 'Deploy app for first time'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
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

  task :restart do
    invoke 'unicorn:stop'

    # Safe timeout for unicorn stopping
    sleep 5

    invoke 'unicorn:start'
  end
end
