class AddFieldsToSystemStates < ActiveRecord::Migration
  def self.up
    add_column :system_states, :network, :string
    add_column :system_states, :firmware_version, :string
    add_column :system_states, :gprs_signal, :integer
  end

  def self.down
    remove_column :system_states, :network
    remove_column :system_states, :firmware_version
    remove_column :system_states, :gprs_signal
  end
end
