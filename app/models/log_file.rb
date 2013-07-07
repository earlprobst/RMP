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
# Filename: log_file.rb
#
#-----------------------------------------------------------------------------

class LogFile < ActiveRecord::Base

  mount_uploader :file, LogUploader

  belongs_to :gateway

  validates_presence_of :file
  validates_associated :gateway

  LOG_DELETE_LIMIT = 20
end
