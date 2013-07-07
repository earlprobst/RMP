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
# Filename: gateways_helper.rb
#
#-----------------------------------------------------------------------------

module GatewaysHelper
  def gateway_state(state)
    case state
      when 'online'
        image_tag "led_green.png", :alt => state.camelize
      when 'late'
        image_tag "led_yellow.png", :alt => state.camelize
      when 'offline'
        image_tag "led_red.png", :alt => state.camelize
      else
        image_tag "led_grey.png", :alt => state.camelize
    end
  end

  def removemeasurements_link_style(action)
    action ? 'display:none' : 'display:block'
  end
  
  def removemeasurements_msg_style(action)
    action ? 'display:block' : 'display:none'
  end

  def shutdown_link_style(action_id)
    (action_id.nil? || action_id == 0) ? 'display:block' : 'display:none'
  end
  
  def shutdown_msg_style(action_id)
    action_id == 2 ? 'display:block' : 'display:none'
  end
  
  def reboot_msg_style(action_id)
    action_id == 1 ? 'display:block' : 'display:none'
  end

  def vpn_link_style(action_id)
    (action_id.nil? || action_id == 0) ? 'display:block' : 'display:none'
  end
  
  def vpn_msg_style(action_id)
    action_id == 1 ? 'display:block' : 'display:none'
  end
  
  def synchronize_msg_style(synchronize)
    synchronize ? 'display:block' : 'display:none'
  end
  
  def synchronize_link_style(synchronize)
    synchronize ? 'display:none' : 'display:block'
  end
  
  def configuration_default_fields()
    Configuration.new.attributes.reject {|key, value| key == "modified" || key == "state_xml" || key == "tz_data"}.keys.join(',')
  end
  
  def configuration_default_values()
    Configuration.new.attributes.reject {|key, value| key == "modified" || key == "state_xml" || key == "tz_data"}.values.join(',')
  end
end
