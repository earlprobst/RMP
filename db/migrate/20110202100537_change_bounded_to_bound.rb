class ChangeBoundedToBound < ActiveRecord::Migration
  def self.up
    rename_column :medical_device_states, :bounded, :bound
  end

  def self.down
    rename_column :medical_device_states, :bound, :bounded
  end
end
