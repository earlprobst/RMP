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
# Filename: session_store.rb
#
#-----------------------------------------------------------------------------

# Be sure to restart your server when you modify this file.

RemoteManagementPlatform::Application.config.session_store :cookie_store, :key => '_remote_management_platform_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# RemoteManagementPlatform::Application.config.session_store :active_record_store
