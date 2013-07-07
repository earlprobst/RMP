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
# Filename: project_user_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class ProjectUserTest < ActiveSupport::TestCase

  context "A user" do
    setup do
      @project = Factory(:project)
    end

    should 'be admin of a project' do
      user = User.new(:name => "User", :email => "user@test.me", :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => true, :project_users_attributes => [{:project_id => @project.id, :role => "admin"}])
      assert user.valid?
    end

    should 'be user of a project' do
      user = User.new(:name => "User", :email => "user@test.me", :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => true, :project_users_attributes => [{:project_id => @project.id, :role => "user"}])
      assert user.valid?
    end

    should 'not be admin and user for the same project' do
      user = User.create(:name => "User", :email => "user@test.me", :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => true, :project_users_attributes => [{:project_id => @project.id, :role => "user"}])
      project_user_admin = ProjectUser.new(:project_id => @project.id, :user_id => user.id, :role => "admin")
      assert !project_user_admin.valid?
    end
  end

  context "A superadmin user" do
    setup do
      @user = Factory(:user, :superadmin => true, :project_users_attributes => [])
      @project = Factory(:project)
    end

    should "not be admin or user of a project" do
      user = User.create(:name => "User", :email => "user@test.me", :password => "password", :password_confirmation => "password",
              :superadmin => true, :active => true, :project_users_attributes => [{:project_id => @project.id, :role => "user"}])
      assert !user.valid?
    end
  end

end
