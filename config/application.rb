require 'active_record'
Dir[File.dirname(__FILE__) + '/../concerns/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each {|file| require file }

ActiveRecord::Base.establish_connection("postgres://sig@localhost/delegate-audit")
