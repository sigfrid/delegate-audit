require 'active_record'
Dir[File.dirname(__FILE__) + '/../app/*.rb'].each {|file| require file }

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'db/delegate-audit.sqlite3'
)
