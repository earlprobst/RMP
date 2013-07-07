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
# Filename: ethernet_ip_assignment_method.rb
#
#-----------------------------------------------------------------------------

class EthernetIPAssignmentMethod

  def self.types
    {
      1 => 'DHCP',
      2 => 'Fixed IP'
    }
  end

  def self.to_collection
    types.values.zip(types.keys).sort
  end

end
