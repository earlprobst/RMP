class AddAndDeleteGprsAndPstnConfigurationFields < ActiveRecord::Migration
  def self.up
    add_column :configurations, :pstn_username, :string
    add_column :configurations, :pstn_password, :string
    add_column :configurations, :pstn_dialin, :string
    add_column :configurations, :pstn_mtu, :integer

    add_column :configurations, :gprs_pin, :string
    add_column :configurations, :gprs_password, :string

    rename_column :configurations, :gprs_login, :gprs_username

    remove_column :configurations, :gprs_pstn
    remove_column :configurations, :gprs_code
    remove_column :configurations, :gprs_dialin
  end

  def self.down
    remove_column :configurations, :pstn_username
    remove_column :configurations, :pstn_password
    remove_column :configurations, :pstn_dialin
    remove_column :configurations, :pstn_mtu

    remove_column :configurations, :gprs_pin
    remove_column :configurations, :gprs_password

    rename_column :configurations, :gprs_username, :gprs_login

    add_column :configurations, :gprs_pstn, :string
    add_column :configurations, :gprs_code, :string
    add_column :configurations, :gprs_dialin, :string
  end
end
