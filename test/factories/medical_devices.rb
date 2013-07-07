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
# Filename: medical_devices.rb
#
#-----------------------------------------------------------------------------

Factory.define :medical_device, :class => MedicalDevice do |f|
  f.gateway                     { |gateway| gateway.association(:gateway) }
  f.type_id                     2
  f.serial_number               { |md| "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" +
                                       "0#{md.type_id == 3 ? 4 : md.type_id}#{(Time.now.year-1).to_s[2,2]}" +
                                       "#{(1..6).inject([]) { |sn_parts, i| sn_parts << SecureRandom.random_number(10) }.join}" }

  f.after_build do |medical_device|
    if medical_device.users.empty?
      if medical_device.type_id == 3
        medical_device.users_attributes = [{:md_user => 1, :default => true, :gender => 'female', :physical_activity => 'average', :age => 50, :height => 160, :units => 'kg/cm', :display_body_fat => true, :display_body_water => true, :display_muscle_mass => true}]
      else
        medical_device.users_attributes = [{:md_user => 1, :default => true}]
      end
    end
  end
end
