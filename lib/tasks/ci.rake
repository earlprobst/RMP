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
# Filename: ci.rake
#
#-----------------------------------------------------------------------------

namespace :ci do
  task :copy_yml do
    unless ENV["TRAVIS"]
      sh "cp #{Rails.root}/config/database.yml.example #{Rails.root}/config/database.yml"
    end
  end

  desc "Prepare for CI and run entire test suite"
  task :build do
    Rake::Task['db:create'].invoke
    Rake::Task['environment'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['cucumber'].invoke
    Rake::Task['test'].invoke
  end

  task :deploy do
    sh "cap staging deploy"
  end

  desc "Prepare for CI and run entire test suite"
  task :run => ['ci:copy_yml', 'ci:build'] do
  end

end
