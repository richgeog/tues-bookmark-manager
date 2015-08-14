require 'data_mapper'
require 'dm-validations'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")

require './models/link'
require './models/tag'
require './models/user'

DataMapper.finalize

DataMapper.auto_migrate!