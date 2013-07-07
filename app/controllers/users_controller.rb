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
# Filename: users_controller.rb
#
#-----------------------------------------------------------------------------

class UsersController < ApplicationController
  load_and_authorize_resource

  def new
    @user = User.new
    Project.manage_by(@current_user).each do |project|
      @user.project_users.build(:project_id => project.id)
    end
  end

  def create
      @user = User.new(params[:user])
      @user.new_random_password

    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "The account has been created."
      redirect_to users_path
    else
      project_users = @user.project_users.collect {|project_user| project_user.project_id}
      Project.manage_by(@current_user).each do |project|
        @user.project_users.build(:project_id => project.id) unless project_users.include?(project.id)
      end
      render :action => :new
    end
  end

  def show
    if(params[:id].nil?)
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  def index
    if @current_user.is_superadmin?
      @users = User.paginate :page => params[:page], :order => 'name ASC'
    elsif @current_user.is_admin_of_any_project?
        @users = User.of_projects_manage_by(@current_user).paginate :page => params[:page], :order => 'name ASC'
    else
        redirect_to account_path
    end
  end

  def edit
    @user = User.find(params[:id])
    project_users = @user.project_users.collect {|project_user| project_user.project_id}
    Project.manage_by(@current_user).each do |project|
      @user.project_users.build(:project_id => project.id) unless project_users.include?(project.id)
    end
  end

  def update
    @user = User.find(params[:id]) # makes our views "cleaner" and more consistent

    if params[:user][:project_users_attributes].present?
      params[:user][:project_users_attributes].each do |project_user|
        project_user[1][:_destroy] = true if project_user[1]["role"].blank?
      end
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated!"
      redirect_to user_path
    else
      project_users = @user.project_users.collect {|project_user| project_user.project_id}
      Project.manage_by(@current_user).each do |project|
        @user.project_users.build(:project_id => project.id) unless project_users.include?(project.id)
      end
      render :action => :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    destroyed = false
    
    if @current_user.is_superadmin? || (@user.projects - Project.manage_by(@current_user) == [])
      @user.destroy
      if @user.destroyed?
        flash[:notice] = "The user was successfully removed of the application"
        destroyed = true
      end
    else
      destroyed = true
      @user.project_users.each do |project_user|
        if Project.manage_by(@current_user).include?(project_user.project)
          project_user.destroy
          destroyed = false unless project_user.destroyed?
        end
      end
      if destroyed
        flash[:notice] = "The user was successfully removed of your projects"
      end
    end
    
    if !destroyed
      flash[:error] = "Unable to delete the user"
      @user.errors.each { |msg| flash[:error] += "<br/> #{msg}" } if @user.errors
    end
    
    redirect_back_or_default users_path
  end
  
end
