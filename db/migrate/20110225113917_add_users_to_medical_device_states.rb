class AddUsersToMedicalDeviceStates < ActiveRecord::Migration
  def self.up
    add_column :medical_device_states, :users_mask, :integer
    add_column :medical_device_states, :default_user, :integer
  end

  def self.down
    remove_column :medical_device_states, :users_mask
    remove_column :medical_device_states, :default_user
  end
end
