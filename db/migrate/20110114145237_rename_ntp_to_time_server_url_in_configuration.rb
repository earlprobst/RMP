class RenameNtpToTimeServerUrlInConfiguration < ActiveRecord::Migration
  def self.up
    rename_column :configurations, :ntp, :time_server_url
    change_column :configurations, :time_server_url, :string, :default => "http://brmp.aentos.net/api/time", :null => false
  end

  def self.down
    rename_column :configurations, :time_server_url, :ntp
    change_column :configurations, :ntp, :string, :null => false
  end
end
