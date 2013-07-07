#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: configurations.rb
#
#-----------------------------------------------------------------------------

Factory.define :configuration, :class => Configuration do |f|
  f.network_1_id                      "1"
  f.network_2_id                      "2"
  f.network_3_id                      "3"
  f.ethernet_ip_assignment_method_id  "1"
  f.ethernet_ip                       ""
  f.ethernet_mtu                      ""
  f.ethernet_default_gateway_ip       ""
  f.gprs_provider                     "movistar.es"
  f.gprs_apn                          "movistar.es"
  f.gprs_phone_number                 "555555555"
  f.gprs_mtu                          "16436"
  f.gprs_username                     "movistar"
  f.gprs_password                     "abcd1234"
  f.gprs_pin                          "1234"
  f.pstn_username                     "pstnuser"
  f.pstn_password                     "pstnpass"
  f.pstn_mtu                          "1234"
  f.pstn_dialin                       "123465789"
  f.configuration_update_interval     "300" # 5 minutes (in sec.)
  f.status_interval                   "604800" # 1 week (in sec.)
  f.send_data_interval                "21600" # 6 horas (in sec.)
  f.time_zone                         "UTC"
  f.connectors                        []
  f.software_update_interval          "86400" # 1 day (in sec.)
  f.repo_type                         "stable"
  f.temporal_configuration_update_interval nil

  [:ethernet, :gprs, :pstn].each do |interface|
    f.sequence("#{interface}_proxy_server".to_sym)    { "http://my.proxy.rb" }
    f.sequence("#{interface}_proxy_port".to_sym)      { "8080" }
    f.sequence("#{interface}_proxy_username".to_sym)  { "proxy_user" }
    f.sequence("#{interface}_proxy_password".to_sym)  { "proxy_pass" }
    f.sequence("#{interface}_proxy_ssl".to_sym)       { true }
  end
end
