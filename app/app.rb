require 'sinatra/base'
require_relative './data_mapper_setup'
# require_relative './models/link'

class BookmarkManager < Sinatra::Base
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

  # start the server if ruby file executed directly
  run! if app_file == $0
end
