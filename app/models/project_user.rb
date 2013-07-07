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
# Filename: project_user.rb
#
#-----------------------------------------------------------------------------

class ProjectUser < ActiveRecord::Base

  ROLES = %w[admin user]

  belongs_to :user
  belongs_to :project

  validates_presence_of :role
  validates_uniqueness_of :user_id, :scope => :project_id
  validates_associated :project, :user

end
