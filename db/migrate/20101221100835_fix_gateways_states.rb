class FixGatewaysStates < ActiveRecord::Migration
  def self.up
    Gateway.all.each do |gateway|
      if gateway.last_contact.present?
        if gateway.token.present?
          if gateway.measurements.present? || gateway.log_files.present?
            gateway.update_attributes({:authenticated_at => (gateway.last_contact - 1.day), :installed_at => (gateway.last_contact - 1.day)})
          else
            gateway.update_attributes({:authenticated_at => (gateway.last_contact - 1.day)})
          end
        end
      end
    end
  end

  def self.down
  end
end
