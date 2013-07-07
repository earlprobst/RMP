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
# Filename: ability.rb
#
#-----------------------------------------------------------------------------

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_superadmin?

      can :manage, Project
      can :manage, User do |action, user_project|
        action == :destroy ? (user_project != user) : true
      end
      can :manage, Gateway
      can :manage, MedicalDevice
      can :read, Measurement
      can :destroy, LogFile

    else

      can :update, Project do |project|
        user.is_project_admin?(project)
      end
      
      can :read, Project do |project|
        project ? user.projects.include?(project) : true
      end

      can :create, User do |user_project|
        (user_project && user_project.valid?) ? user.is_admin_of_a_shared_project_with?(user_project) : user.is_admin_of_any_project?
      end

      can :destroy, User do |user_project|
        user_project ? ((user_project != user) && user.is_admin_of_a_shared_project_with?(user_project)) : true
      end
      
      can [:read, :update], User do |user_project|
        user_project ? ((user_project == user) || user.is_admin_of_a_shared_project_with?(user_project)) : true
      end

      can :read, Gateway do |gateway|
        gateway ? user.projects.include?(gateway.project) : true
      end

      can [:update, :destroy, :clear_log_files], Gateway do |gateway|
        user.is_project_admin?(gateway.project)
      end

      #TODO: make this ability for a project in concrete
      can :create, Gateway do |gateway|
        user.is_admin_of_any_project?
      end

      can :read, MedicalDevice do |medical_device|
        medical_device ? user.projects.include?(Gateway.find(medical_device.gateway_id).project) : true
      end

      can [:update, :destroy], MedicalDevice do |medical_device|
          user.is_project_admin?(medical_device.gateway.project)
      end

      can :create, MedicalDevice do |medical_device, gateway|
        gateway ? user.is_project_admin?(gateway.project) : user.is_admin_of_any_project?
      end

      can :read, Measurement do |measurement|
        measurement ? user.projects.include?(measurement.medical_device.gateway.project) : true
      end

      can :destroy, LogFile do |log_file|
        user.is_project_admin?(log_file.gateway.project)
      end

    end

  end
end
