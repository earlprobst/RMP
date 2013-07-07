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
# Filename: medical_device_user.rb
#
#-----------------------------------------------------------------------------

class MedicalDeviceUser < ActiveRecord::Base

  belongs_to :medical_device
  # Validations in the MedicalDevice model

  def params_completed?
    gender.present? && physical_activity.present? && age.present? && height.present? && units.present?
  end

  def display_body_fat_to_s
    display_body_fat ? 'true' : 'false'
  end

  def display_body_water_to_s
    display_body_water ? 'true' : 'false'
  end

  def display_muscle_mass_to_s
    display_muscle_mass ? 'true' : 'false'
  end

end
