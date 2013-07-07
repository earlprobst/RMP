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
# Filename: delayed_job.god
#
#-----------------------------------------------------------------------------

rails_env =  ENV['RAILS_ENV'] || "production"
rails_root = ENV['RAILS_ROOT'] || "/var/rails/biocomfort_rmp_#{rails_env}/current"

God.watch do |w|
  w.name          = "delayed_job-worker"
  w.group         = "delayed_job-workers"
  w.interval      = 30.seconds
  w.env           = { "RAILS_ENV" => rails_env }
  w.dir           = rails_root
  w.start         = "script/delayed_job start"
  w.stop          = "script/delayed_job stop"
  w.restart       = "script/delayed_job restart"
  w.start_grace   = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file      = "#{rails_root}/tmp/pids/delayed_job.pid"
  w.uid           = 'deploy'
  w.gid           = 'deploy'

  w.behavior(:clean_pid_file)

  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 150.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end
  
  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end
  
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end
  
  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
