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
# Filename: paths.rb
#
#-----------------------------------------------------------------------------

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /login page/
      login_path

    when /new session page/
      '/user_session'

    when /user profile/
      '/account'

    when /users/
      '/users'

    when /the user "([^\"]*)"/
      user_path(User.where(:email => $1)[0])

    when /add new user/
      new_user_path

   when /edit user "([^\"]*)"/
      edit_user_path(User.where(:email => $1)[0])

    when /projects/
      '/projects'

    when /the project "([^\"]*)"/
      project_path(Project.where(:name => $1)[0])

   when /edit project "([^\"]*)"/
      edit_project_path(Project.where(:name => $1)[0])

    when /add new project/
      new_project_path

    when /^add new gateway$/
      new_gateway_path()

    when /edit gateway "([^\"]*)"/
      edit_gateway_path(Gateway.where(:serial_number => $1)[0])

    when /^the gateway "([^\"]*)"$/
      gateway_path(Gateway.find_by_serial_number($1))
      
    when /^the configuration xml of the gateway "([^\"]*)"$/
      gateway_path(Gateway.find_by_serial_number($1), :format => :xml)

    when /^gateways$/
      gateways_path

    when /edit medical device "([^\"]*)" of the gateway "([^\"]*)"/
      edit_gateway_medical_device_path(Gateway.where(:serial_number => $2)[0], MedicalDevice.where(:serial_number => $1)[0])

    when /^measurements$/
      measurements_path

    when /^measurements of the medical device "([^\"]*)" of the gateway "([^\"]*)"$/
      gateway_medical_device_measurements_path(Gateway.where(:serial_number => $2)[0], MedicalDevice.where(:serial_number => $1)[0])

    when /medical device "([^\"]*)" of the gateway "([^\"]*)"/
      gateway_medical_device_path(Gateway.find_by_serial_number($2), MedicalDevice.find_by_serial_number($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
