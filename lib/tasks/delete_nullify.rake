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
# Filename: delete_nullify.rake
#
#-----------------------------------------------------------------------------

namespace :nullified_registers do
  
  desc "Regenerate all the configuration XML"
  task :destroy => :environment do
    LogFile.where(:gateway_id => nil).find_in_batches(:batch_size => 10) do |group|
      sleep(50) # Make sure it doesn't get too crowded in there!
      group.each { |lf| lf.destroy }
    end
  end
end
