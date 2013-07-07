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
# Filename: staging.rb
#
#-----------------------------------------------------------------------------

#############################################################
#       Settings
#############################################################
set :rails_env, "staging"

# Application Settings
set :application,   "#{app_name}"
set :user,          "deploy"
set :deploy_to,     "/var/rails/#{app_name}_staging"
set :use_sudo,      false
set :keep_releases, 5

# Server Roles
role :web, "brmp.aentos.net"
role :app, "brmp.aentos.net"
role :db,  "brmp.aentos.net", :primary => true

# Whenever Settings
set :whenever_command, "RACK_ENV=staging bundle exec whenever"
set :whenever_update_flags, "--update-crontab #{app_name} --set environment=staging"
require "whenever/capistrano"
