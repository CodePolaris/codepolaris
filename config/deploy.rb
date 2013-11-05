require 'bundler/capistrano'

set :application, "codepolaris.com"
set :repo_url, 'git://github.com/marcosserpa/codepolaris.git'

set :user, "polaris"
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
set :scm, :git

server application, :app, :web, :db, :primary => true
set :branch, "master" #proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_via, :remote_cache # Otherwise always clone the repository at the deploy

namespace :deploy do
  desc 'Start application'
  task :start do ; end

  desc 'Stop application'
  task :stop do ; end

  desc 'Restart application'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

# Unicorn tasks
require 'capistrano-unicorn'
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
