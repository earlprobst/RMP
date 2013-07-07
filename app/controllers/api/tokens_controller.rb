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
# Filename: tokens_controller.rb
#
#-----------------------------------------------------------------------------

class Api::TokensController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate_with_serial_and_mac

  actions :create
  respond_to :xml

  def create
    if @gateway.token.blank? || @gateway.debug_mode
      @gateway.token = Digest::SHA1.hexdigest([Time.zone.now.utc, rand, @gateway.serial_number, @gateway.mac_address].join)
      @gateway.save!
      @gateway.register_authenticated
      @gateway.activities_date.token_request = Time.now
      @gateway.activities_date.save

      render :xml => @gateway.token_xml
    else
      render :xml => '', :status => :forbidden
    end
  end

end
