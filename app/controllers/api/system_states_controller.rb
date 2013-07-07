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
# Filename: system_states_controller.rb
#
#-----------------------------------------------------------------------------

class Api::SystemStatesController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate

  actions :create, :show
  respond_to :xml

  def create
    begin
      @system_state = SystemState.from_xml(request.body.read, @gateway)
      
      if @system_state.valid?
        @gateway.activities_date.system_state_upload = Time.now
        @gateway.activities_date.save
      end

      create!(:xml => @system_state)
    rescue
      render :xml => '', :status => 422
    end
  end

end
