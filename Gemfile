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
# Filename: Gemfile
#
#-----------------------------------------------------------------------------

source 'http://rubygems.org'

gem 'rails', '3.0.17'
gem 'mail', '~> 2.2.15'
gem 'newrelic_rpm'
gem 'hoptoad_notifier'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'pg', :require => 'pg'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'

gem 'formtastic', '~> 1.1.0'
gem 'haml-rails'
gem 'compass' , '~> 0.10.5'
gem 'compass-960-plugin'
gem 'fancy-buttons'
gem 'will_paginate', '~> 3.0.pre2'

gem 'cancan', '~> 1.3.4'
gem 'inherited_resources', '~> 1.1.2'
gem 'carrierwave'
gem 'active_hash'
gem 'whenever', '>= 0.7.3', :require => false

gem "capistrano"
gem "capistrano-ext", :require => "capistrano"
gem "rvm-capistrano"

# To add forign keys
gem 'foreigner'

# Send measurements with failed connectors in background
gem 'delayed_job'

# dirty fix
# http://crimpycode.brennonbortz.com/?p=42
# http://groups.google.com/group/cukes/browse_thread/thread/5028306893c2c54a/0395dd08468aa8b8?lnk=gst&q=bad+content+body+(EOFError)&pli=1
gem 'escape_utils'

group :development do
  gem 'hirb'
  gem 'wirble'
  gem "parallel_tests"
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'xml-simple'
  gem "mynyml-redgreen", :require => "redgreen"
  gem "cucumber", "~> 1.2.0"
  gem "cucumber-rails", "~> 1.3.0", require: false
  gem "selenium-webdriver"
  gem "database_cleaner", ">=0.5.0"
  gem "spork", ">=0.8.4"
  gem "judit-pickle"
  gem "launchy"
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'mocha'
  gem "poltergeist"
end

if not ENV["TRAVIS"]
  group :test, :development do
    gem "debugger"
  end
end
