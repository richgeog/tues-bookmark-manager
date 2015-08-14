module Armadillo
  module Routes
    class Index < Base

      get '/' do
        erb :'launch_page/launch'
        # redirect to ('/links')
      end

    end
  end
end