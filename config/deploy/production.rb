set :stage, :production
set :branch, 'master'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :production
set :deploy_to, "/home/deploy/projects/#{fetch(:app_path)}"

server 'otvorenesudy.sk', user: 'deploy', roles: %w[app db web]
