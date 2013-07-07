class AddPackagesToSystemStates < ActiveRecord::Migration
  def self.up
    add_column :system_states, :packages, :string
  end

  def self.down
    remove_column :system_states, :packages
  end
end
