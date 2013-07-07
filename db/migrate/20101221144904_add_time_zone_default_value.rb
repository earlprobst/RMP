class AddTimeZoneDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :configurations, :time_zone, :string, :default => "UTC", :null => false
    change_column :configurations, :tz_data, :string, :default => "UTC+0", :null => false
  end

  def self.down
    change_column :configurations, :time_zone, :string, :null => false
    change_column :configurations, :tz_data, :string, :null => false
  end
end
