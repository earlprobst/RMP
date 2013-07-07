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
# Filename: medical_device_type.rb
#
#-----------------------------------------------------------------------------

class MedicalDeviceType

  def self.types
    {
      1 => 'tenso-comfort (BPM105)',
      2 => 'gluco-comfort (BGM105)',
      3 => 'scaleo-comfort (BSC105)'
    }
  end

  def self.to_collection
    types.values.zip(types.keys).sort
  end

end
