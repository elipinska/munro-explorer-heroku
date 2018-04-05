require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/hike.rb' )
require_relative( '../models/hiker.rb' )
require_relative( '../models/munro.rb' )

get '/hikes' do
  @hikes = Hike.all
  erb(:"hikes/index")
end

get '/hikes/new' do
  @hikers = Hiker.all()
  @munros = Munro.all
  erb(:"hikes/new")
end


post '/hikes' do
  if params['date'] == ""
    redirect to("/hikes/new/error")
  else
    hike = Hike.new(params)
    hike.save
    hiker = Hiker.find_by_id(hike.hiker_id)
    if hiker.munro_goal == hiker.unique_hikes_no
      redirect to("/hikers/#{hiker.id}/goal_completed")
    else
      redirect to("/hikes")
    end
  end
end


get '/hikes/new/error' do
  @error = "Please complete the date field."
  @hikers = Hiker.all()
  @munros = Munro.all
  erb(:"hikes/new")
end

get '/hikes/:id/edit/error' do
  @error = "Please complete the date field."
  @hikers = Hiker.all()
  @munros = Munro.all
  @hike = Hike.find_by_id(params['id'])
  erb(:"hikes/edit")
end

get '/hikes/:id/edit' do
  @hikers = Hiker.all()
  @munros = Munro.all()
  @hike = Hike.find_by_id(params['id'])
  erb(:"hikes/edit")
end

post '/hikes/:id' do
  if params['date'] == ""
    redirect to("/hikes/#{params['id']}/edit/error")
  else
    hike = Hike.new(params)
    hike.update
    redirect to "/hikes"
  end
end

post '/hikes/:id/delete' do
  hike = Hike.find_by_id(params[:id])
  hike.delete()
  redirect to("/hikes")
end
