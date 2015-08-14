require 'pry'
require 'sinatra/base'
require 'sinatra/flash'
# require 'sinatra/partial'
require_relative './data_mapper_setup'

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

  get '/' do
    redirect to ('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
  	erb :'links/new'
  end

  post '/links' do
  	link = Link.new(url: params[:url],
                    title: params[:title])
      params[:tags] == "" ? params[:tags] = "untagged" : params[:tags] = params[:tags]
      tags_array = (params[:tags]).split(" ")
      tags_array.each do |word|
      tag = Tag.create(name: word)
      link.tags << tag
      link.save
    end
      redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    # byebug
    @user = User.new(email: params[:email],
                    password: params[:password],
                    password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.now[:notice] = 'goodbye!'
    erb :'sessions/new'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
