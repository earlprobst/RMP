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
# Filename: regenerate_configuration_xml.rake
#
#-----------------------------------------------------------------------------

namespace :configuration do
  
  desc "Regenerate all the configuration XML"
  task :regenerate_xml => :environment do
    Gateway.all.each {|gw| gw.create_configuration_xml}
  end
end
