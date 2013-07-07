class AddStatusFieldsToMedicalDevices < ActiveRecord::Migration
  def self.up
    add_column :medical_devices, :bounded, :boolean, :default => false
    add_column :medical_devices, :in_time, :boolean, :default => false
    add_column :medical_devices, :low_battery, :boolean, :default => false
  end

  def self.down
    remove_column :medical_devices, :bounded
    remove_column :medical_devices, :in_time
    remove_column :medical_devices, :low_battery
  end
end
