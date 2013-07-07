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
# Filename: user_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "When check the gateways of an user" do
    setup do
      @project_a = Factory(:project)
      @project_b = Factory(:project)
      @project_c = Factory(:project)
      @gateway_a1 = Factory(:gateway, :project => @project_a)
      @gateway_a2 = Factory(:gateway, :project => @project_a)
      @gateway_b = Factory(:gateway, :project => @project_b)
      @user_ab = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}, {:project_id => @project_b.id, :role => "admin"}])
      @user_c = Factory(:user, :project_users_attributes => [{:project_id => @project_c.id, :role => "user"}])
    end

    should "include all the gateways of his projects" do
      assert_equal 3, @user_ab.gateways.count
      assert @user_ab.gateways.include?(@gateway_a1)
      assert @user_ab.gateways.include?(@gateway_a2)
      assert @user_ab.gateways.include?(@gateway_b)
    end

    should "return an empty array if the user haven't gateways" do
      assert_equal [], @user_c.gateways
    end
  end

    context "When check the measurement of an user" do
    setup do
      @project_a = Factory(:project)
      @project_b = Factory(:project)
      @project_c = Factory(:project)
      @gateway_a1 = Factory(:gateway, :project => @project_a)
      @gateway_a2 = Factory(:gateway, :project => @project_a)
      @medical_device_a1_1 = Factory(:medical_device, :gateway => @gateway_a1)
      @medical_device_a1_2 = Factory(:medical_device, :gateway => @gateway_a1)
      @measurement_a1_1_1 = Factory(:blood_glucose, :medical_device => @medical_device_a1_1)
      @measurement_a1_1_2 = Factory(:blood_glucose, :medical_device => @medical_device_a1_1)
      @measurement_a1_2_1 = Factory(:blood_glucose, :medical_device => @medical_device_a1_2)

      @gateway_b = Factory(:gateway, :project => @project_b)
      @medical_device_b1 = Factory(:medical_device, :gateway => @gateway_b)
      @measurement_b1_1 = Factory(:blood_glucose, :medical_device => @medical_device_b1)

      @user_ab = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}, {:project_id => @project_b.id, :role => "admin"}])
      @user_c = Factory(:user, :project_users_attributes => [{:project_id => @project_c.id, :role => "user"}])
    end

    should "include all the measurements of all the gateways of his projects" do
      assert_equal 4, @user_ab.measurements.count
      assert @user_ab.measurements.include?(@measurement_a1_1_1)
      assert @user_ab.measurements.include?(@measurement_a1_1_2)
      assert @user_ab.measurements.include?(@measurement_a1_2_1)
      assert @user_ab.measurements.include?(@measurement_b1_1)
    end

    should "return an empty array if the user haven't measurements" do
      assert_equal [], @user_c.measurements
    end
  end

  context "When check the users of a project" do
    setup do
      @project_a = Factory(:project)
      @project_b = Factory(:project)
      @admin_a = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}])
      @user_a1 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @user_a2 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @admin_ab = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}, {:project_id => @project_b.id, :role => "admin"}])
      @user_b1 = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "admin"}])
      @user_b2 = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "user"}])

      @project_users_a = User.of_project(@project_a)
      @project_users_b = User.of_project(@project_b)
    end

    should "include all the users of project a" do
      assert_equal 4, @project_users_a.count
      assert @project_users_a.include?(@admin_a)
      assert @project_users_a.include?(@user_a1)
      assert @project_users_a.include?(@user_a2)
      assert @project_users_a.include?(@admin_ab)
    end

    should "include all the users of project b" do
      assert_equal 3, @project_users_b.count
      assert @project_users_b.include?(@admin_ab)
      assert @project_users_b.include?(@user_b1)
      assert @project_users_b.include?(@user_b2)
    end
  end

  context "When check the users of a project manage by other user" do
    setup do
      @project_a = Factory(:project)
      @project_b = Factory(:project)
      @admin_a = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}])
      @user_a1 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @user_a2 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @admin_ab = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}, {:project_id => @project_b.id, :role => "admin"}])
      @user_b1 = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "admin"}])
      @user_b2 = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "user"}])

      @project_users_a = User.of_projects_manage_by(@admin_a)
      @project_users_ab = User.of_projects_manage_by(@admin_ab)
    end

    should "include all the users of projects manage by admin_a" do
      assert_equal 4, @project_users_a.count
      assert @project_users_a.include?(@admin_a)
      assert @project_users_a.include?(@user_a1)
      assert @project_users_a.include?(@user_a2)
      assert @project_users_a.include?(@admin_ab)
    end

    should "not include other users of projects not manage by admin_a" do
      assert !(@project_users_a.include?(@user_b1))
      assert !(@project_users_a.include?(@user_b2))
    end

    should "include all the users of projects manage by admin_ab" do
      assert_equal 6, @project_users_ab.count
      assert @project_users_ab.include?(@admin_a)
      assert @project_users_ab.include?(@user_a1)
      assert @project_users_ab.include?(@user_a2)
      assert @project_users_ab.include?(@admin_ab)
      assert @project_users_ab.include?(@user_b1)
      assert @project_users_ab.include?(@user_b2)
    end
  end

  context "When check the admin users of a project" do
    setup do
      @project_a = Factory(:project)
      @project_b = Factory(:project)
      @admin_a1 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}])
      @admin_a2 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}])
      @user_a1 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @user_a2 = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "user"}])
      @admin_ab = Factory(:user, :project_users_attributes => [{:project_id => @project_a.id, :role => "admin"}, {:project_id => @project_b.id, :role => "admin"}])
      @admin_b = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "admin"}])
      @user_b = Factory(:user, :project_users_attributes => [{:project_id => @project_b.id, :role => "user"}])

      @project_admins_a = User.admin_of_project(@project_a)
      @project_admins_b = User.admin_of_project(@project_b)
    end

    should "include all the admin users of the project a" do
      assert_equal 3, @project_admins_a.count
      assert @project_admins_a.include?(@admin_a1)
      assert @project_admins_a.include?(@admin_a2)
      assert @project_admins_a.include?(@admin_ab)
    end

    should "include all the admin users of the project b" do
      assert_equal 2, @project_admins_b.count
      assert @project_admins_b.include?(@admin_ab)
      assert @project_admins_b.include?(@admin_b)
    end
  end

end
