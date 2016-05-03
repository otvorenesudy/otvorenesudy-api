set :stage, :production
set :branch, 'prosecutors-property-declarations'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :production
set :deploy_to, "/home/deploy/projects/#{fetch(:app_path)}"

server '195.146.144.210', user: 'deploy', roles: %w{app db web}
