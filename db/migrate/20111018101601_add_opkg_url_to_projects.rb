class AddOpkgUrlToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :opkg_url, :string, :default => "http://opkg.biocomfort.de", :null => false
  end

  def self.down
    remove_column :projects, :opkg_url
  end
end
