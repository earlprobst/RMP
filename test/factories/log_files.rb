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
# Filename: log_files.rb
#
#-----------------------------------------------------------------------------

Factory.define :log_file, :class => LogFile do |f|
  f.file              { File.open("#{Rails.root.to_s}/test/factories/dummy_log#{rand 3}") }
  f.gateway           { |gateway| gateway.association(:gateway) }
end
