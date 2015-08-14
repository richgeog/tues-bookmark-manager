module Armadillo
  module Routes
    class Index < Base

      get '/' do
        redirect to ('/links')
      end

    end
  end
end