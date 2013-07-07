class AddForeignKeyToMedicalDeviceStates < ActiveRecord::Migration
  def self.up
    add_foreign_key :medical_device_states, :system_states, :dependent => :delete
  end

  def self.down
    remove_foreign_key :medical_device_states, :system_states
  end
end
