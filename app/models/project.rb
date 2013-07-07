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
# Filename: project.rb
#
#-----------------------------------------------------------------------------

class Project < ActiveRecord::Base

  has_many :gateways, :dependent => :destroy
  has_many :medical_devices, :through => :gateways

  has_many :project_users
  has_many :users, :through => :project_users

  before_destroy :destroy_users

  validates_presence_of :name, :contact_person, :email, :address, :rmp_url, :medical_data_url
  validates_presence_of :opkg_url, :message => "Project package repository url can't be blank"
  validates_uniqueness_of :name
  
  before_save :format_rmp_url

  scope :admin_user_is, lambda {|user| 
    joins("INNER JOIN project_users on projects.id = project_users.project_id
           INNER JOIN users on project_users.user_id = users.id").where("users.id = ? AND project_users.role = 'admin'", user.id)
  }

  cattr_reader :per_page
  @@per_page = 10
  
  def format_rmp_url
    self.rmp_url.gsub!(/\/$/, '')
  end

  def self.manage_by(user)
    user.is_superadmin? ? Project.all : Project.admin_user_is(user)
  end

  def measurements
    Measurement.project_id_is(self.id)
  end

  def destroy_users
    User.of_project(self).each {|user| user.destroy if user.projects.count == 1}
    self.project_users.each {|project_user| project_user.destroy}
  end
  
  def configuration_url
    "#{rmp_url}/configuration"
  end
  
  def log_url
    "#{rmp_url}/log_files"
  end
  
  def configuration_state_url
    "#{rmp_url}/configuration/state"
  end
  
  def system_state_update_url
    "#{rmp_url}/system_states.xml"
  end
  
  def token_url
    "#{rmp_url}/tokens"
  end

  def actions_url
    "#{rmp_url}/actions"
  end

end
