#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: deploy.rb
#
#-----------------------------------------------------------------------------

# Bundler Integration
# http://github.com/carlhuda/bundler/blob/master/lib/bundler/capistrano.rb
require 'bundler/capistrano'

# RVM Integration
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
require "rvm/capistrano"                                # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2'                           # Or whatever env you want it to run in.
set :rvm_type, :system  # Copy the exact line. I really mean :system here

#{"require 'hoptoad_notifier/capistrano'" if hoptoad }

set :default_stage, "staging"
set :stages, %w(production staging)
require 'capistrano/ext/multistage'

set :app_name,      "biocomfort_rmp"
# Git Settings
set :scm,           :git
set :branch,        "master"
set :repository,    "git@github.com:aentos/biocomfort_rmp.git"
set :deploy_via,    :remote_cache

# Uses local instead of remote server keys, good for github ssh key deploy.
ssh_options[:forward_agent] = true

#############################################################
#       Deploy
#############################################################

namespace :deploy do
  
  desc "Regenerate configurations XML"
  task :regenerate_configuration_xml do
    run "cd #{current_path}; bundle exec rake RACK_ENV=#{fetch :rails_env} --trace configuration:regenerate_xml"
  end

  desc "Create the needed additional shared directories"
  task :setup_shared do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/uploads"
  end

  desc "Restart passenger process"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} does nothing for passenger"
    task t, :roles => :app do ; end
  end

  desc "Create the needed symlinks to shared"
  task :symlink_shared do
    run "ln -fs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Create asset packages for production"
  task :package_assets do
    run "cd #{current_path} && rake asset:packager:build_all"
  end

  desc "Migrate the database"
  task :migrate do
    run "cd #{current_path}; bundle exec rake RACK_ENV=#{fetch :rails_env} --trace db:migrate"
  end

  desc "Seed the database"
  task :seed do
    run "cd #{current_path} && bundle exec rake RACK_ENV=#{fetch :rails_env} --trace db:seed"
  end
end

namespace :delayed_job do
  [:start, :stop, :restart].each do |t|
    desc "#{t.capitalize} the delayed_job process"
    task t, :roles => :app do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job #{t}"
    end
  end
end

after 'deploy:setup', 'deploy:setup_shared'
after 'deploy:symlink', 'deploy:symlink_shared', 'deploy:migrate', 'deploy:seed', 'deploy:regenerate_configuration_xml', 'delayed_job:restart'
after 'deploy', 'deploy:cleanup'

require './config/boot'
require 'hoptoad_notifier/capistrano'
