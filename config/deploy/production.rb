set :stage, :production
set :branch, 'main'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :production
set :user, 'deploy'
set :deploy_to, "/home/deploy/projects/#{fetch(:app_path)}"

server 'otvorenesudy1.server.wbsprt.com', user: 'deploy', roles: %w[app db web]
