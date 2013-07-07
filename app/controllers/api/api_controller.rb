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
# Filename: api_controller.rb
#
#-----------------------------------------------------------------------------

class Api::ApiController < InheritedResources::Base

  private

    def authenticate_with_serial_and_mac
      authenticate_or_request_with_http_basic do |serial_number, mac_address|
        @gateway = Gateway.find_by_serial_number_and_mac_address(serial_number, mac_address)
        @gateway.register_contact if @gateway
      end
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @gateway = Gateway.find_by_token(token)
        @gateway.register_contact if @gateway        
      end
    end

end
