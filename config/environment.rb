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
# Filename: environment.rb
#
#-----------------------------------------------------------------------------

# Load the rails application
require File.expand_path('../application', __FILE__)

require 'time_zone_data'

# Initialize the rails application
RemoteManagementPlatform::Application.initialize!
