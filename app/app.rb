require 'sinatra/base'
require_relative './data_mapper_setup'
require 'sinatra/flash'
require 'pry'

class BookmarkManager < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

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
    @user = User.new(email: params[:email],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    elsif @user.email == ''
      flash.now[:notice] = "Please enter valid email address"
      erb :'users/new'
    elsif @user.password_confirmation != @user.password
      flash.now[:notice] = "Password and confirmation password do not match"
      erb :'users/new'
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
