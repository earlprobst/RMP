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
# Filename: production.rb
#
#-----------------------------------------------------------------------------

#############################################################
#       Settings
#############################################################
set :rails_env, "production"

# Application Settings
set :application,   "#{app_name}"
set :user,          "deploy"
set :deploy_to,     "/var/rails/#{app_name}_production"
set :use_sudo,      false
set :keep_releases, 5

# Server Roles
role :web, "rmp.biocomfort.de"
role :app, "rmp.biocomfort.de"
role :db,  "rmp.biocomfort.de", :primary => true

# Whenever Settings
set :whenever_command, "RACK_ENV=production bundle exec whenever"
set :whenever_update_flags, "--update-crontab #{app_name} --set environment=production"
require "whenever/capistrano"
