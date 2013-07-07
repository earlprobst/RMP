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
# Filename: my_vitali.rb
#
#-----------------------------------------------------------------------------

module MyVitali
  extend self

  attr_accessor :url
  attr_accessor :token

  def volatile(new_url, new_token)
    old_url = url
    old_token = token

    self.url = new_url
    self.token = new_token

    yield
  ensure
    self.url = old_url
    self.token = old_token
  end

end
