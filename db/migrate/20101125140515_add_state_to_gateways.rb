class AddStateToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :state, :string

    Gateway.all.each do |gateway|
      gateway.token.nil? ? gateway.update_attributes({:state => "uninstalled"}) : gateway.update_attributes({:state => "authenticated"})
    end

  end

  def self.down
    remove_column :gateways, :state
  end
end
