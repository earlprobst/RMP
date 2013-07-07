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
# Filename: times_controller.rb
#
#-----------------------------------------------------------------------------

class Api::TimesController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate

  actions :show
  respond_to :xml

  def show
    @gateway.activities_date.time_request = Time.now
    @gateway.activities_date.save
    options = { :indent => 2}
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    render :xml => xml.tag!("utc-time", Time.now.gmtime.to_s[0..18]), :status => :ok
  end

end
