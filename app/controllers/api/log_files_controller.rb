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
# Filename: log_files_controller.rb
#
#-----------------------------------------------------------------------------

class Api::LogFilesController < Api::ApiController

  skip_before_filter :require_user
  before_filter :authenticate

  actions :create
  respond_to :xml

  def create
    # store the log file as temporary file
    tmp_filename = "tmp/" + Digest::SHA1.hexdigest([Time.zone.now.utc, rand].join)
    f = File.new(tmp_filename, "wb")
    f.write(request.body.read)
    f.close

    @log_file = LogFile.new(:gateway => @gateway)
    @log_file.file = File.open(tmp_filename)

    #delete the temporary file
    File.delete("#{Rails.root.to_s}/#{tmp_filename}") if File.exist?("#{Rails.root.to_s}/#{tmp_filename}")

    if @log_file.save
      @gateway.activities_date.log_file_upload = Time.now
      @gateway.activities_date.save
      render :xml => '', :status => :created
    else
      render :xml => '', :status => :unprocessable_entity
    end
  end

end
