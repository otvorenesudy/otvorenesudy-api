require 'capistrano/deploy'
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'whenever/capistrano'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/scm/git-with-submodules'
install_plugin Capistrano::SCM::Git::WithSubmodules

require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
