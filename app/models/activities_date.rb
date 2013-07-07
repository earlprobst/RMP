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
# Filename: activities_date.rb
#
#-----------------------------------------------------------------------------

class ActivitiesDate < ActiveRecord::Base
  belongs_to :gateway
  validates_associated :gateway
  validates_presence_of :gateway_id
  validates_uniqueness_of :gateway_id
end
