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
# Filename: ability_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class AbilityTest < ActiveRecord::TestCase
  context "An admin user" do
    setup do
      @user = Factory(:user, :superadmin => true, :project_users_attributes => [])
      @ability = Ability.new(@user)
    end

    should 'be able to manage users' do
      assert @ability.can?(:manage, User.new)
    end

    should 'not be able to delete itself' do
      assert @ability.cannot?(:destroy, @user)
    end

    should 'be able to manage projects' do
      assert @ability.can?(:manage, Project.new)
    end

    should 'be able to manage gateways' do
      assert @ability.can?(:manage, Gateway.new)
    end

    should 'be able to manage medical devices' do
      assert @ability.can?(:manage, MedicalDevice.new)
    end

    should 'be able to read measurement' do
      assert @ability.can?(:read, Measurement.new)
    end
  end

  context "An user who is admin of a project" do
    setup do
      @project = Factory(:project)
      @admin = Factory(:user, :project_users_attributes => [{:project_id => @project.id, :role => "admin"}])
      @project_user = Factory(:user, :project_users_attributes => [{:project_id => @project.id, :role => "user"}])
      @other_user = Factory(:user, :project_users_attributes => [{:project_id => Factory(:project).id, :role => "user"}])
      @ability = Ability.new(@admin)
    end

    should 'not be able to manage users' do
      assert @ability.cannot?(:manage, User.new)
    end

    should 'be able to create users for his own projects' do
      user = User.new
      user.projects = [@project ]
      assert @ability.can?(:create, user)
    end

    should 'be able to edit users for his own project' do
      assert @ability.can?(:update, @project_user)
    end

    should 'be able to delete users for his own project' do
      assert @ability.can?(:destroy, @project_user)
    end

    should 'not be able to delete itself' do
      assert @ability.cannot?(:destroy, @admin)
    end

    should 'be able to read users for his own project' do
      assert @ability.can?(:read, @project_user)
    end

    should 'not be able to read users for other project' do
      assert @ability.cannot?(:read, @other_user)
    end

    should 'not be able to manage projects' do
      assert @ability.cannot?(:manage, Project.new)
    end

    should 'be able to edit his own project' do
      assert @ability.can?(:update, @project)
    end

    should 'be able to read his own project' do
      assert @ability.can?(:read, @project)
    end

    should 'not be able to read others project' do
      assert @ability.cannot?(:read, Factory(:project))
    end

    should 'be able to read his owns gateways' do
      assert @ability.can?(:read, Gateway.new(:project_id => @project.id))
    end

    should 'be able to create gateways for his owns projects' do
      assert @ability.can?(:create, Gateway.new(:project_id => @project.id))
    end

    should 'be able to update his owns gateways' do
      assert @ability.can?(:update, Gateway.new(:project_id => @project.id))
    end

    should 'be able to destroy his owns gateways' do
      assert @ability.can?(:destroy, Gateway.new(:project_id => @project.id))
    end

    should 'be able to clear log files of his owns gateways' do
      assert @ability.can?(:clear_log_files, Gateway.new(:project_id => @project.id))
    end

    should 'not be able to clear log files of other gateways' do
      assert @ability.cannot?(:clear_log_files, Gateway.new(:project_id => Factory(:project).id))
    end

    should 'not be able to manage others gateways' do
      assert @ability.cannot?(:manage, Gateway.new(:project_id => Factory(:project).id))
    end

    should 'be able to read his owns medical devices' do
      assert @ability.can?(:read, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'be able to update his owns medical devices' do
      assert @ability.can?(:update, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'be able to destroy his owns medical devices' do
      assert @ability.can?(:destroy, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'be able to create medical devices for his owns gateways' do
      assert @ability.can?(:create, MedicalDevice.new, Factory(:gateway, :project_id => @project.id))
    end

    should 'not be able to manage others medical devices' do
      assert @ability.cannot?(:manage, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => Factory(:project).id).id))
    end

  end

  context "An user who is not admin of a project" do
    setup do
      @project = Factory(:project)
      @project = Factory(:project)
      @user = Factory(:user, :project_users_attributes => [{:project_id => @project.id, :role => "user"}])
      @other_user = Factory(:user, :project_users_attributes => [{:project_id => Factory(:project).id, :role => "user"}])
      @ability = Ability.new(@user)
    end

    should 'not be able to manage users' do
      assert @ability.cannot?(:manage, User.new)
    end

    should 'not be able to create users' do
      assert @ability.cannot?(:create, User.new)
    end

    should 'not be able to destroy users' do
      assert @ability.cannot?(:destroy, User.new)
    end

    should 'be able to read his own profile' do
      assert @ability.can?(:read, @user)
    end

    should 'not be able to read others users profile' do
      assert @ability.cannot?(:read, @other_user)
    end

    should 'be able to update his own profile' do
      assert @ability.can?(:update, @user)
    end

    should 'not be able to edit others profile' do
      assert @ability.cannot?(:update, @other_user)
    end

    should 'not be able to manage projects' do
      assert @ability.cannot?(:manage, Project.new)
    end

    should 'not be able to create projects' do
      assert @ability.cannot?(:create, Project.new)
    end

    should 'not be able to destroy projects' do
      assert @ability.cannot?(:destroy, Project.new)
    end

    should 'not be able to update projects' do
      assert @ability.cannot?(:update, Project.new)
    end

    should 'be able to read his owns projects' do
      assert @ability.can?(:read, @project)
    end

    should 'not be able to read other projects' do
      assert @ability.cannot?(:read, Factory(:project))
    end

    should 'not be able to manage gateways' do
      assert @ability.cannot?(:manage, Gateway.new(:project_id => @project.id))
    end

    should 'not be able to create gateways' do
      assert @ability.cannot?(:create, Gateway.new(:project_id => @project.id))
    end

    should 'not be able to update gateways' do
      assert @ability.cannot?(:update, Gateway.new(:project_id => @project.id))
    end

    should 'not be able to destroy gateways' do
      assert @ability.cannot?(:destroy, Gateway.new(:project_id => @project.id))
    end

    should 'be able to read his owns gateways' do
      assert @ability.can?(:read, Gateway.new(:project_id => @project.id))
    end

    should 'not be able to read others gateways' do
      assert @ability.cannot?(:read, Gateway.new(:project_id => Factory(:project).id))
    end

    should 'not be able to manage medical devices' do
      assert @ability.cannot?(:manage, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'not be able to create medical devices' do
      assert @ability.cannot?(:create, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'not be able to update medical devices' do
      assert @ability.cannot?(:update, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'not be able to destroy medical devices' do
      assert @ability.cannot?(:destroy, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'be able to read his owns medical devices' do
      assert @ability.can?(:read, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => @project.id).id))
    end

    should 'not be able to read others medical devices' do
      assert @ability.cannot?(:read, MedicalDevice.new(:gateway_id => Factory(:gateway, :project_id => Factory(:project).id).id))
    end

  end

end
