require( 'sinatra' )
require( 'sinatra/contrib/all' )
require 'sinatra/activerecord'
require_relative('controllers/hike_controller')
require_relative('controllers/hiker_controller')
require_relative('controllers/munro_controller')
require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/munro-explorer')

class App < Sinatra::Base
  get '/' do
    erb( :index )
  end

  get '/about' do
    erb( :about )
  end
end
