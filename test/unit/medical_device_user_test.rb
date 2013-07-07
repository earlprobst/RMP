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
# Filename: medical_device_user_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class MedicalDeviceUserTest < ActiveSupport::TestCase

  context "When I create a medical device user" do
    setup do
      @md = Factory(:medical_device, :users_attributes => [{:md_user => 1, :default => true}])
    end

    should "not have the same md_user number of other user of the same medical device" do
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}])
      assert md.valid?
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}, {:md_user => 1, :default => false}])
      assert !md.valid?
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}, {:md_user => 2, :default => false}])
      assert md.valid?
    end

    should "not be default if there is other default user for the same medical device" do
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}])
      assert md.valid?
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}, {:md_user => 2, :default => true}])
      assert !md.valid?
      md = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => true}, {:md_user => 2, :default => false}])
      assert md.valid?
    end

    should "have completed all the user attributes if the medical device is a scale" do
      md = Factory.build(:medical_device, :serial_number => '1234560400123456', :type_id => 3, :users_attributes => [{:md_user => 1, :default => true, :gender => 'female', :physical_activity => 'average', :age => 50, :height => 160, :units => nil, :display_body_fat => nil, :display_body_water => true, :display_muscle_mass => true}])
      assert !md.valid?, 'a scales user should have completed all the fields'
      assert md.errors[:users].present?
      md.users.first.units = 'kg/cm'
      md.users.first.display_body_fat = false
      assert md.valid?
    end

    should "not have any user attributes if the medical device isn't a scale" do
      md = Factory.build(:medical_device, :serial_number => '1234560100123456', :type_id => 1, :users_attributes => [{:md_user => 1, :default => true, :gender => nil, :physical_activity => nil, :age => nil, :height => nil, :units => nil, :display_body_fat => nil, :display_body_water => nil, :display_muscle_mass => nil}])
      assert md.valid?, 'a tenso/gluco user should not have completed all the fields'
    end
  end

end
