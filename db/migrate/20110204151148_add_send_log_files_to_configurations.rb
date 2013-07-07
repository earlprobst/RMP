class AddSendLogFilesToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :send_log_files, :boolean, :default => false
    Gateway.all.each do |gateway|
      if gateway.debug_mode
        gateway.configuration.send_log_files = true
      else
        gateway.configuration.send_log_files = false
      end
    end
    change_column :configurations, :send_log_files, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :configurations, :send_log_files
  end
end
