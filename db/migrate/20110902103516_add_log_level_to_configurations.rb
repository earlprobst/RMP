class AddLogLevelToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :log_level, :integer
  end

  def self.down
    remove_column :configurations, :log_level
  end
end
