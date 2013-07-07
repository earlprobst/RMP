class DeleteNotNullFromSystemStateId < ActiveRecord::Migration
  def self.up
    change_column :medical_device_states, :system_state_id, :integer, :null => true
  end

  def self.down
    change_column :medical_device_states, :system_state_id, :integer, :null => false
  end
end
