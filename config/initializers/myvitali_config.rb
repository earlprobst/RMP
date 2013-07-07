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
# Filename: myvitali_config.rb
#
#-----------------------------------------------------------------------------

require "my_vitali"

if File.exist?("/etc/myvitali/config")
  load("/etc/myvitali/config")
end

MyVitali.url = ENV['MY_VITALI_URL'] || "invalid.host"
MyVitali.token = ENV['MY_VITALI_TOKEN'] || "empty-token"

