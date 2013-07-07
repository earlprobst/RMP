class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.belongs_to  :project,       :null => false
      t.string      :serial_number, :null => false
      t.string      :mac_address,   :null => false
      t.string      :token,         :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :gateways
  end
end
