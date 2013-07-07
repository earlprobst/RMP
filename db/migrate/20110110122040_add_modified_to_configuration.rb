class AddModifiedToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :modified, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :configurations, :modified
  end
end
