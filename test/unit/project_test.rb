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
# Filename: project_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "When I create a project" do
    setup do
      @project = Factory(:project, :name => "Test project", :rmp_url => "http://server.com/api/")
    end
    
    should "format the rmp url by deleting the last /" do
      assert_equal  "http://server.com/api", @project.rmp_url
    end

    should "not have the same name of other project" do
      project = Project.new(:name => "Test project", :contact_person => "Test person", :email => "project@test.me", :address => "Project Addr")
      assert !project.valid?
    end
    
    should "return all the urls needed for the configuration xml" do
      assert_equal "http://server.com/api/system_states.xml", @project.system_state_update_url
      assert_equal "http://server.com/api/configuration/state", @project.configuration_state_url
      assert_equal "http://server.com/api/log_files", @project.log_url
      assert_equal "http://server.com/api/configuration", @project.configuration_url
      assert !@project.medical_data_url.blank?
      assert !@project.rmp_url.blank?
    end
  end

  context "When I destroy a project with users, gateways, medical devices and measurements" do
      setup do
        @project_a = Factory(:project)
        @project_b = Factory(:project)
        @gateway_a = Factory(:gateway, :project => @project_a)
        @medical_device_a = Factory(:medical_device, :type_id => 2, :gateway => @gateway_a)
        Factory(:blood_glucose, :medical_device => @medical_device_a)
        Factory(:user, :email => "superadmin@test.me", :superadmin => true, :project_users_attributes => [])
        Factory(:user, :email => "user_a@test.me", :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
        Factory(:user, :email => "user_ab@test.me", :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}, {:project_id => @project_b.id, :role => "user"}])
        @project_a.destroy
      end

      should "be destroyed all the gateways of this project" do
        assert_equal 0, Gateway.count
      end

      should "be destroyed all the medical devices of this project" do
        assert_equal 0, MedicalDevice.count
      end

      should "be destroyed all the measurements of this project" do
        assert_equal 0, Measurement.count
      end

      should "be destroyed all the users that only belongs to this project" do
        assert_equal 1, ProjectUser.count, "Fail: ProjectUsers count doesn't match"
        assert User.where(:email => "superadmin@test.me").present?, "Fail: Superadmin destroyed!"
        assert User.where(:email => "user_ab@test.me").present?, "Fail: User of other project destroyed!"
        assert_equal @project_b, User.where(:email => "user_ab@test.me").first.projects.first, "Fail: Can't access to the project of an user"
        assert_equal 2, User.count, "Fail: Users count doesn't match"
      end
  end
end
