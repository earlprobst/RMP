class InitializeAllLogLevelToDefault < ActiveRecord::Migration
  def self.up
    update "update configurations set log_level = 4"
  end

  def self.down
  end
end
