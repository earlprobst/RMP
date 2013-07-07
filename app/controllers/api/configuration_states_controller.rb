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
# Filename: configuration_states_controller.rb
#
#-----------------------------------------------------------------------------

class Api::ConfigurationStatesController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate

  actions :show
  respond_to :xml

  def show
    @gateway.activities_date.configuration_state_request = Time.now
    @gateway.activities_date.save

    render :xml => @gateway.configuration.state_xml, :status => :ok
  end

end
