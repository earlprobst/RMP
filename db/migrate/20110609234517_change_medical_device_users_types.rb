class ChangeMedicalDeviceUsersTypes < ActiveRecord::Migration
  def self.up
    change_column :medical_device_users, :physical_activity, :string
    change_column :medical_device_users, :units, :string
  end

  def self.down
    remove_column :medical_device_users, :physical_activity
    remove_column :medical_device_users, :units
    add_column :medical_device_users, :physical_activity, :integer
    add_column :medical_device_users, :units, :integer
  end
end
