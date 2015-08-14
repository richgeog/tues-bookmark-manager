require 'sinatra/base'
require './app/controller/base'
require './app/controller/index_controller'
require './app/controller/links_controller'
require './app/controller/sessions_controller'
require './app/controller/tags_controller'
require './app/controller/users_controller'
require_relative '../data_mapper_setup'
require 'pry'
require 'sinatra/partial'

module Armadillo
  class BookmarkManager < Sinatra::Base

    use Routes::Links
    use Routes::Tags
    use Routes::Users
    use Routes::Sessions
    use Routes::Index

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end