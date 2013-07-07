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
# Filename: network.rb
#
#-----------------------------------------------------------------------------

class Network

  def self.types
    {
      1 => 'Ethernet',
      2 => 'GPRS',
      3 => 'Modem'
    }
  end

  def self.to_collection
    types.values.zip(types.keys).sort
  end

end
