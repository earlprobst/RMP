class AddStatesFieldsToGateways < ActiveRecord::Migration
  def self.up
    add_column :gateways, :authenticated_at, :datetime
    add_column :gateways, :installed_at, :datetime

    Gateway.all.each do |gateway|
      case gateway.state
        when 'authenticated'
          gateway.update_attributes({:authenticated_at => gateway.last_contact})
        when 'installed'
          gateway.update_attributes({:authenticated_at => gateway.last_contact, :installed_at => gateway.last_contact})
        else
          unless gateway.state == 'uninstalled'
            gateway.update_attributes({:authenticated_at => gateway.last_contact - 1.day, :installed_at => gateway.last_contact - 1.day})
          end
      end
    end

    remove_column :gateways, :state
  end

  def self.down
    add_column :gateways, :state, :string

    Gateway.all.each do |gateway|
      case gateway.intervals_without_contact
      when 0

        if gateway.installed_at.present?
          if gateway.installed_at != gateway.last_contact
            gateway.update_attributes({:state => 'online'})
          else
            gateway.update_attributes({:state => 'installed'})
          end
        elsif gateway.authenticated_at.present?
          gateway.update_attributes({:state => 'authenticated'})
        else
          gateway.update_attributes({:state => 'uninstalled'})
        end

      when 1
        gateway.update_attributes({:state => 'late'})
      else
        gateway.update_attributes({:state => 'offline'})
      end
    end

    remove_column :gateways, :authenticated_at
    remove_column :gateways, :installed_at
  end
end
