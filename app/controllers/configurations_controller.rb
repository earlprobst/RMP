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
# Filename: configurations_controller.rb
#
#-----------------------------------------------------------------------------

class ConfigurationsController < InheritedResources::Base
  belongs_to :gateway
  load_and_authorize_resource :gateway, :find_by => :serial_number

  actions :show
  respond_to :html

  protected

    def begin_of_association_chain
      @gateway
    end

    def resource
      begin_of_association_chain.configuration
    end
    
end
