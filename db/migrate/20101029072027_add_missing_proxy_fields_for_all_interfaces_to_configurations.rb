class AddMissingProxyFieldsForAllInterfacesToConfigurations < ActiveRecord::Migration
  def self.up
    [:ethernet, :gprs, :pstn].each do |interface|
      add_column :configurations, "#{interface}_proxy_server".to_sym, :string
      add_column :configurations, "#{interface}_proxy_port".to_sym, :integer
      add_column :configurations, "#{interface}_proxy_username".to_sym, :string
      add_column :configurations, "#{interface}_proxy_password".to_sym, :string
      add_column :configurations, "#{interface}_proxy_ssl".to_sym, :boolean
    end
  end

  def self.down
    [:ethernet, :gprs, :pstn].each do |interface|
      remove_column :configurations, "#{interface}_proxy_server".to_sym
      remove_column :configurations, "#{interface}_proxy_port".to_sym
      remove_column :configurations, "#{interface}_proxy_username".to_sym
      remove_column :configurations, "#{interface}_proxy_password".to_sym
      remove_column :configurations, "#{interface}_proxy_ssl".to_sym
    end
  end
end
