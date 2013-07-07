class AddDefaultLogLevelToConfigurations < ActiveRecord::Migration
  def self.up
    change_column :configurations, :log_level, :integer, :default => 4
  end

  def self.down
    change_column :configurations, :log_level, :integer
  end
end
