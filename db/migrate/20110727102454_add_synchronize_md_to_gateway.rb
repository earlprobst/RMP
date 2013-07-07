class AddSynchronizeMdToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :synchronize_md, :boolean
  end

  def self.down
    remove_column :gateways, :synchronize_md
  end
end
