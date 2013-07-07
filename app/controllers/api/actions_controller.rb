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
# Filename: actions_controller.rb
#
#-----------------------------------------------------------------------------

class Api::ActionsController < Api::ApiController
  skip_before_filter :require_user
  before_filter :authenticate
  after_filter :reset_actions

  actions :index
  respond_to :xml

  def index
    if @gateway
      @gateway.activities_date.configuration_state_request = Time.now
      @gateway.activities_date.save
      
      if @gateway.has_modified_or_has_pending_actions?
        render :xml => @gateway.actions_xml, :status => :ok
      else
        render :xml => "", :status => :not_modified
      end
    end
  end

  private

  def reset_actions
    if @gateway.present? and @gateway.has_modified_or_has_pending_actions?
      @gateway.synchronize_md = false   if @gateway.synchronize_md
      @gateway.shutdown_action_id = 0   if @gateway.shutdown_action_id != 0
      @gateway.vpn_action_id = 0        if @gateway.vpn_action_id != 0
      @gateway.removemeasurements_action = false
      @gateway.configuration.update_configuration_xml
      @gateway.configuration.modify_configuration_state false
      @gateway.save
    end
  end
end
