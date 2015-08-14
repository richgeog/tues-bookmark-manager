module Armadillo
  module Routes
    class Sessions < Base

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

    end
  end
end