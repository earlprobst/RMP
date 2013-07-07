class ChangeMedicalDeviceUserHeight < ActiveRecord::Migration
  def self.up
    change_column :medical_device_users, :height, :integer
  end

  def self.down
    change_column :medical_device_users, :height, :decimal
  end
end
