require './app/controller/links_controller'
require './app/controller/sessions_controller'
require './app/controller/tags_controller'
require './app/controller/users_controller'
require_relative './../data_mapper_setup_controller'

require 'pry'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'

class BookmarkManager < Sinatra::Base
  register Sinatra::Flash
  # register Sinatra::Partial
  use Rack::MethodOverride

  enable :sessions
  set :session_secret, 'super secret'

  helpers do
    def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
