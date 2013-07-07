class AddLastContactToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :last_contact, :datetime
  end

  def self.down
    remove_column :gateways, :last_contact
  end
end
