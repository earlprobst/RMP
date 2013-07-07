class ChangePackagesTypeInSystemStates < ActiveRecord::Migration
  def self.up
    change_column :system_states, :packages, :text
  end

  def self.down
  end
end
