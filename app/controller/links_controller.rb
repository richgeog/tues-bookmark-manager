module Armadillo
  module Routes
    class Links < Base

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

    end
  end
end