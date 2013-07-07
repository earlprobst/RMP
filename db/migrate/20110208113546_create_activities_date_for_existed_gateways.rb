class CreateActivitiesDateForExistedGateways < ActiveRecord::Migration
  def self.up
    Gateway.all.each do |gateway|
      if gateway.activities_date.nil?
        activities_date = ActivitiesDate.create(:gateway_id => gateway.id)
        activities_date.save(:validate => false)
      end
    end
  end

  def self.down
  end
end
