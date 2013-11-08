require "bundler/capistrano"
require "rvm/capistrano"

server "162.243.70.102", :web, :app, :db, primary: true

set :application, "codepolaris"
set :user, "polaris"
set :port, 22
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :copy
set :use_sudo, true
set :rvm_ruby_string, "ruby-2.0.0-p247"

set :scm, "git"
set :repository, "git@github.com:marcosserpa/codepolaris.git"
set :branch, "master"
set :rvm_type, :system

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  task :precompile_assets do
    run <<-CMD
      rm -rf #{latest_release}/public/assets &&
      mkdir -p #{shared_path}/assets &&
      ln -s #{shared_path}/assets #{latest_release}/public/assets
    CMD
    set(:answer, Capistrano::CLI.ui.ask("Do you want to skip asset compilation? (only 'yes' will skip)") )
    if answer != 'yes'
      run_locally "rake assets:precompile"
      run_locally "cd public; tar -zcvf assets.tar.gz assets"
      top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
      run "cd #{shared_path}; tar -zxvf assets.tar.gz; rm assets.tar.gz"
      run_locally "rm public/assets.tar.gz"
      run_locally "rm -rf public/assets"
    end
  end

  task :update_sitemap do
    run "cd #{release_path} && RAILS_ENV=production bundle exec rake sitemap:refresh"
  end

  task :nginx_restart do
    run "cd #{release_path} && sudo service nginx restart"
  end

  after 'deploy:update_code', 'deploy:precompile_assets', 'deploy:update_sitemap', 'deploy:nginx_restart'

  before "deploy", "deploy:check_revision"
end