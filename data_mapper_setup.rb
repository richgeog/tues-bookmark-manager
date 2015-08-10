require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './app/link'

DataMapper.finalize

Data_mapper.auto_upgrade!