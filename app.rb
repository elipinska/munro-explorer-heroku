require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative('controllers/hike_controller')
require_relative('controllers/hiker_controller')
require_relative('controllers/munro_controller')


  get '/' do
    erb( :index )
  end

  get '/about' do
    erb( :about )
  end
