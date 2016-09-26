require 'active_record'
Dir[File.dirname(__FILE__) + '/../app/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }

ActiveRecord::Base.establish_connection("postgres://sig@localhost/delegate-audit")
