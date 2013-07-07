class AddConfigurationStateUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :configuration_state_url, :string, :default => "http://brmp.aentos.net/api/configuration/state", :null => false
  end

  def self.down
    remove_column :projects, :configuration_state_url
  end
end
