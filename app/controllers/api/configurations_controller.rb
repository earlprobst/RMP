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

class Api::ConfigurationsController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate
  after_filter :reset_syncronization_and_shutdown

  actions :show
  respond_to :xml

  def show
    @gateway.register_installed unless @gateway.installed_at.present?
    @gateway.activities_date.configuration_request = Time.now
    @gateway.activities_date.save
    @gateway.configuration.modify_configuration_state(false)
    @gateway.save

    @gateway.configuration.update_attribute(:temporal_configuration_update_interval, nil)

    if @gateway.configuration.xml.nil?
      @gateway.create_configuration_xml
    end

    render :xml => @gateway.configuration.xml, :status => :ok
  end

  private
    
    def reset_syncronization_and_shutdown
      if @gateway && @gateway.synchronize_md
        @gateway.update_attribute(:synchronize_md, false)
        @gateway.configuration.update_configuration_xml
        @gateway.configuration.modify_configuration_state(true)
        @gateway.save
      end
      
      if @gateway && !@gateway.shutdown_action_string.blank?
        @gateway.update_attribute(:shutdown_action_id, 0)
        @gateway.configuration.update_configuration_xml
        @gateway.configuration.modify_configuration_state(true)
        @gateway.save
      end
    end
end
