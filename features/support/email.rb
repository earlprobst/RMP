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
# Filename: email.rb
#
#-----------------------------------------------------------------------------

module EmailHelpers
  # Maps a name to an email address. Used by email_steps

  def email_for(to)
    case to
  
    # add your own name => email address mappings here
  
    when /^#{capture_model}$/
      model($1).email
  
    when /^"(.*)"$/
      $1
  
    else
      to
    end
  end
end

World(EmailHelpers)
