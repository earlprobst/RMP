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
# Filename: user_steps.rb
#
#-----------------------------------------------------------------------------

Given /^I am logged in with role admin$/ do
  user = Factory(:user, :superadmin => true, :active => "true", :project_users_attributes => [])
  visit root_path
  fill_in("Email", :with => user.email)
  fill_in("Pass", :with => user.password)
  click_button("Login")
end

Given /^I am logged in with login "([^"]*)"$/ do |login|
  visit root_path
  fill_in("Email", :with => login)
  fill_in("Pass", :with => "password")
  click_button("Login")
end

Given /^I am not logged in$/ do
  visit logout_path
end

Then /^I should be able to log in with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  UserSession.new(:email => email, :password => password).save.should == true
end

Given /^(?:admin|I) create (?:a|my) user account successfuly with email "([^\"]*)"$/ do |email|
  steps %Q{
      Given I am logged in with role admin
       When I go to add new user
        And I fill in "Name" with "Biouser"
        And I fill in "Email" with "#{email}"
        And I check "Global permissions"
        And I press "Add user"
       Then 1 email should be delivered to "#{email}"
        And I am not logged in
  }
end

When /^I try to activate an account with wrong activation code$/ do
  visit "/activate/123456"
end

When /^the user "([^"]*)" activate his account$/ do |email|
  User.where(:email => email)[0].activate!
  User.where(:email => email)[0].update_attributes(:password => "password", :password_confirmation => "password")
end

Given /^a superadmin user exists with name: "([^"]*)", email: "([^"]*)"$/ do |name, email|
  user = Factory(:user, :name => name, :email => email,
              :password => "password", :password_confirmation => "password",
              :superadmin => true, :active => "true",
              :project_users_attributes => [])
end

Given /^a normal user exists with name: "([^"]*)", email: "([^"]*)" and belongs to the project_id: "([^"]*)" like "([^"]*)"$/ do |name, email, project_id, role|
  User.create(:name => name, :email => email,
              :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => true,
              :project_users_attributes => [{:project_id => project_id, :role => role}])
end

Given /^an inactive user exists with name: "([^"]*)", email: "([^"]*)" and belongs to the project_id: "([^"]*)" like "([^"]*)"$/ do |name, email, project_id, role|
  User.create(:name => name, :email => email,
              :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => false,
              :project_users_attributes => [{:project_id => project_id, :role => role}])
end

Given /^a normal user exists with name: "([^"]*)", email: "([^"]*)" and belongs to the following projects:$/ do |name, email, table|
  # table is a Cucumber::Ast::Table
  project_users = []
  table.rows_hash.each do |project_id, role|
    if(project_id != "project_id" && role != "role")
      project_users << {:project_id => project_id, :role => role}
    end
  end
  User.create(:name => name, :email => email,
              :password => "password", :password_confirmation => "password",
              :superadmin => false, :active => true,
              :project_users_attributes => project_users)
end
