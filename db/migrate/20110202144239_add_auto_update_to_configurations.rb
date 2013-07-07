class AddAutoUpdateToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :auto_update, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :configurations, :auto_update
  end
end
