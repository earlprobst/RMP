class AddLogsUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :log_url, :string, :default => "http://brmp.aentos.net/api/log_files", :null => false
  end

  def self.down
    remove_column :projects, :log_url
  end
end
