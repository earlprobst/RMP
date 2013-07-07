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
# Filename: gateways.rb
#
#-----------------------------------------------------------------------------

Factory.define :gateway, :class => Gateway do |f|
  f.serial_number     { "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" +
                        "00#{(Time.now.year-1).to_s[2,2]}" +
                        "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" }
  f.mac_address       { (1..6).inject([]) { |mac_parts, i| mac_parts << SecureRandom.hex(2) }.join(":") }
  f.project           { |project| project.association(:project) }
  f.configuration     { |configuration| configuration.association(:configuration) }
  f.location          { Faker::Address }
  f.debug_mode        false
  f.authenticated_at  nil
  f.installed_at      nil
  f.last_contact      nil
  f.synchronize_md    false
  f.shutdown_action_id   0     # Do nothing
  f.vpn_action_id     0
end
