class AddGprsPhoneNumberToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :gprs_phone_number, :string
  end

  def self.down
    remove_column :configurations, :gprs_phone_number
  end
end
