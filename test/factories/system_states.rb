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
# Filename: system_states.rb
#
#-----------------------------------------------------------------------------

Factory.define :system_state, :class => SystemState do |f|
  f.gateway                     { |gateway| gateway.association(:gateway) }
  f.ip                          "1.2.3.4"
  f.network                     "ethernet"
  f.firmware_version            "1.2.3"
  f.gprs_signal                 25
  f.packages                    { [{"name" => "mgw109c", "version" => "1.0.2"}, {"name" => "opkg", "version" => "10.2.3"}] }
end
