worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end 

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Production specific settings
if env == "production"
  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up.
  working_directory '/home/polaris/codepolaris.com/current'
  
  # feel free to point this anywhere accessible on the filesystem
  user 'polaris', 'polaris'
  shared_path = '/home/polaris/codepolaris.com/current'
  
  stderr_path '/home/polaris/codepolaris.com/current/log/unicorn.stderr.log'
  stdout_path '/home/polaris/codepolaris.com/current/log/unicorn.stdout.log'
end