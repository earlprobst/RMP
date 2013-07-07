class AddStateXmlToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :state_xml, :string
    Configuration.all.each do |c|
      # XML
      options = { :indent => 2}
      xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! unless options[:skip_instruct]
      c.state_xml = xml.tag!("modified", c.modified)
      c.save(:validate => false)
    end
    
    # Default XML
    options = { :indent => 2}
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
   
    change_column :configurations, :state_xml, :string, :default => xml.tag!("modified", true)
  end

  def self.down
    remove_column :configurations, :state_xml
  end
end
