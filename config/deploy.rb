# config valid for current version and patch releases of Capistrano
lock "~> 3.13.0"

set :application, "fps"
set :repo_url, "git@github.com:ikondratev/fps.git"


# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/fps"
set :deploy_user, 'deployer'
set :passenger_restart_with_touch, true
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl}

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

after 'deploy:publishing', 'unicorn:restart'

