class AddUsersFieldsToMedicalDevices < ActiveRecord::Migration
  def self.up
    add_column :medical_devices, :users_mask, :integer
    add_column :medical_devices, :default_user, :integer

    MedicalDevice.find_each do |m|
      m.users = (1..(m.number_of_users || 0)).entries
      m.default_user = m.users.first
      m.save!(:validate => false)
    end

    remove_column :medical_devices, :number_of_users
  end

  def self.down
    add_column :medical_devices, :number_of_users, :integer

    MedicalDevice.find_each do |m|
      m.number_of_users = m.users.size
      m.save!(:validate => false)
    end

    remove_column :medical_devices, :users_mask
    remove_column :medical_devices, :default_user
  end
end
