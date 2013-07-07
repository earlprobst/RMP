class AddConfigurationXmlToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :xml, :text
    Configuration.all.each do |c|
      # XML
      c.xml = c.gateway.to_xml
      c.save(:validate => false)
    end
  end

  def self.down
    remove_column :configurations, :xml
  end
end
