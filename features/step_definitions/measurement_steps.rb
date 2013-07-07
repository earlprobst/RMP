Given /^the gateway "(.*?)" has (\d+) measurements$/ do |serial, count|
    gw = Gateway.find_by_serial_number(serial)
    md = Factory(:medical_device, :gateway => gw)
    count.to_i.times { Factory(:blood_glucose, :medical_device => md) }
end

Then /^the gateway "(.*?)" should have no measurements$/ do |serial|
    Gateway.find_by_serial_number(serial).measurements.size.should == 0
end

