class CreateActivitiesDates < ActiveRecord::Migration
  def self.up
    create_table :activities_dates do |t|
      t.belongs_to  :gateway,                    :null => false
      t.datetime    :token_request
      t.datetime    :configuration_request
      t.datetime    :measurement_upload
      t.datetime    :log_file_upload
      t.datetime    :time_request
      t.datetime    :configuration_state_request
      t.datetime    :system_state_upload
      t.timestamps
    end
  end

  def self.down
    drop_table :activities_dates
  end
end
