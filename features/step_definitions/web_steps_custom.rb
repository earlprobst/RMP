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
# Filename: web_steps_custom.rb
#
#-----------------------------------------------------------------------------

Then /^I should accept the next confirm dialog$/ do
  page.evaluate_script("window.confirm = function(msg) { return true; }")
end

Then /^the field "([^\"]*)" should be disable$/ do |label|
  field_labeled(label)['disabled'].should == "disabled"
end

Then /^the field "([^\"]*)" should be enable$/ do |label|
  field_labeled(label)['disabled'].should == nil
end

When /^I should see the following(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    # table is a Cucumber::Ast::Table
    table.raw.each do |r|
      if page.respond_to? :should
        page.should have_content(r[0])
      else
        assert page.has_content?(r[0])
      end
    end
  end
end

When /^I should not see the following(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    # table is a Cucumber::Ast::Table
    table.raw.each do |r|
      if page.respond_to? :should
        page.should have_no_content(r[0])
      else
        assert page.has_no_content?(r[0])
      end
    end
  end
end

Then /^the fields should contain the following:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.rows_hash.each do |field, value|
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  select_node = find_field(field)
  current_value = select_node.value

  if value.blank?
    assert_blank current_value
  else
    option_value = select_node.find("option[text()='#{value.gsub("'", "\\'")}']").value
    assert_equal option_value, current_value
  end
end

Then /^the "([^"]*)" field should be empty$/ do |field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  if field_value.respond_to? :should
    field_value.blank?
  else
    assert_match(nil, field_value)
  end
end

When /^(?:|I )select the following(?: within "([^"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      step %{I select "#{value}" from "#{name}"}
    end
  end
end

When /^(?:|I )check the following(?: within "([^"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.raw.each do |r|
      step %{I check "#{r[0]}"}
    end
  end
end

Then /^the following checkboxes(?: within "([^"]*)") should not be checked?:$/ do |selector, fields|
  with_scope(selector) do
    fields.raw.each do |r|
      step %{the "#{r[0]}" checkbox should not be checked}
    end
  end
end

Then /^the following checkboxes(?: within "([^"]*)") should be checked?:$/ do |selector, fields|
  with_scope(selector) do
    fields.raw.each do |r|
      step %{the "#{r[0]}" checkbox should be checked}
    end
  end
end

Then /^I should see the next list of (.*):$/ do |model, expected_table|
  expected_table.diff!(tableish('table tr', 'td,th'))
end

Given /^wait (\d+) second$/ do |sec|
  sleep sec.to_i
end

When /^wait (\d+) seconds$/ do |sec|
  sleep sec.to_i
end

Then /^the page should have xpath "([^"]*)" visible$/ do |xpath|
  assert page.find(:xpath, xpath).visible?
end

Then /^the page should not have xpath "([^"]*)" visible$/ do |xpath|
  assert !page.find(:xpath, xpath).visible?
end

Then /^the page should have xpath "([^"]*)"$/ do |xpath|
  page.should have_xpath(xpath)
end

Then /^the page should not have xpath "([^"]*)"$/ do |xpath|
  page.should have_no_xpath(xpath)
end


