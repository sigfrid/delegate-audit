require 'active_record_migrations'
ActiveRecordMigrations.load_tasks

task :console do
  exec "irb -I lib -r #{File.dirname(__FILE__)}/config/application.rb"
end
