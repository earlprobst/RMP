class AddNewAttributesToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :ntp, :string
    add_column :configurations, :time_zone, :string
    add_column :configurations, :gprs_login, :string
    add_column :configurations, :gprs_pstn, :string
    add_column :configurations, :gprs_dialin, :string
    add_column :configurations, :gprs_code, :string
  end

  def self.down
    remove_column :configurations, :ntp
    remove_column :configurations, :time_zone
    remove_column :configurations, :gprs_login
    remove_column :configurations, :gprs_pstn
    remove_column :configurations, :gprs_dialin
    remove_column :configurations, :gprs_code
  end
end
