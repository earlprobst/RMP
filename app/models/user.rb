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
# Filename: user.rb
#
#-----------------------------------------------------------------------------

class User < ActiveRecord::Base

  validates_presence_of [:password, :password_confirmation] ,:on => :create
  validates_presence_of :name, :email
  validates_inclusion_of :superadmin, :in => [true, false]
  validate :validates_create_project_users, :on => :create
  validate :validates_update_project_users, :on => :update

  has_many :project_users, :dependent => :delete_all
  has_many :projects, :through => :project_users

  accepts_nested_attributes_for :project_users, :reject_if => proc { |attributes| attributes['role'].blank? }, :allow_destroy => true

  scope :of_project, lambda {|project|
    joins("INNER JOIN project_users on users.id = project_users.user_id
           INNER JOIN projects on project_users.project_id = projects.id").where("projects.id = ?", project.id)
  }

  scope :admin_of_project, lambda {|project|
    joins("INNER JOIN project_users on users.id = project_users.user_id
           INNER JOIN projects on project_users.project_id = projects.id").where("projects.id = ? AND project_users.role = 'admin'", project.id)
  }

  scope :of_projects_manage_by, lambda {|admin_user|
    select("DISTINCT users.*").
    joins("INNER JOIN project_users pu1 on pu1.user_id = users.id
           INNER JOIN projects on pu1.project_id = projects.id
           LEFT OUTER JOIN project_users pu2 on pu2.project_id = projects.id
           INNER JOIN users u2 on u2.id = pu1.user_id").
    where("pu2.user_id = ? AND pu2.role = 'admin'", admin_user)
  }
  
  before_validation(:on => :create) do
    self.reset_perishable_token
    self.reset_single_access_token
  end

  acts_as_authentic do |c|
    c.ignore_blank_passwords = true
    c.disable_perishable_token_maintenance = true
  end

  def validates_create_project_users
    errors.add(:user, "should belong to some project") if project_users.blank? && !superadmin
    errors.add(:user, "superadmin should not belong to a project") if !project_users.blank? && superadmin
  end

  def validates_update_project_users
    blank = project_users.blank? || (project_users.count > 0 && project_users.collect {|p| p.marked_for_destruction?}.count(true) == project_users.count)
    errors.add(:user, "should belong to some project") if blank && !superadmin
    errors.add(:user, "superadmin should not belong to a project") if !blank && superadmin
  end

  def gateways
    Gateway.user_is(self)
  end

  def measurements
    Measurement.user_is(self)
  end

  def is_superadmin?
    self.superadmin
  end

  def is_project_admin?(project)
    Project.manage_by(self).include?(project)
  end

  def is_admin_of_any_project?
    (self.projects & Project.all).collect {|project| self.is_project_admin?(project)}.include?true
  end

  def is_admin_of_a_shared_project_with?(user)
    (self.projects & user.projects).collect {|project| self.is_project_admin?(project)}.include?true
  end

  def activate!
    self.active = true
    save(:validate => false)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    UserMailer.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    UserMailer.welcome(self).deliver
  end

  def new_random_password
    self.password= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{name}--")[0,6]
    self.password_confirmation = self.password
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end


end
