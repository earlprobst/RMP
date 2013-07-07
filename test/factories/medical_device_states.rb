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
# Filename: medical_device_states.rb
#
#-----------------------------------------------------------------------------

Factory.define :medical_device_state, :class => MedicalDeviceState do |f|
  f.system_state                    { |system_state| system_state.association(:system_state) }
  f.medical_device_serial_number    { "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" +
                                      "02#{(Time.now.year-1).to_s[2,2]}" +
                                      "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" }
  f.connection_state                "ONLINE"
  f.bound                           true
  f.low_battery                     false
  f.error_id                        10
  f.date                            Time.now
  f.users                           [1, 2]
  f.default_user                    1
  f.last_modified                   Time.now
end
