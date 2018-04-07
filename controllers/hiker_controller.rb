require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/hiker.rb')

get '/hikers' do
  @hikers = Hiker.all_sorted()
  @most_active = Hiker.most_active()
  @most_indiv_hikes = Hiker.most_indiv_hikes
  erb (:"hikers/index")
end

get '/hikers/new' do
  erb(:"hikers/new")
end


post '/hikers' do
  hiker = Hiker.new(params)
  hiker.save
  redirect to("/hikers")
end

get '/hikers/:id' do
  @hiker = Hiker.find_by_id(params['id'].to_i)
  @unique_hikes = @hiker.unique_hikes
  @unique_hikes_no = @hiker.unique_hikes_no
  erb( :"hikers/show" )
end

get '/hikers/:id/new-hike' do
  @hiker = Hiker.find_by_id(params['id'].to_i)
  @munros = Munro.all
  erb( :"hikers/new-hike" )
end

get '/hikers/:id/new-hike/error' do
  @error = "Please complete the date field."
  @hiker = Hiker.find_by_id(params['id'].to_i)
  @munros = Munro.all
  erb(:"/hikers/new-hike")
end

get '/hikers/:id/edit' do
  @hiker = Hiker.find_by_id(params['id'])
  erb(:"hikers/edit")
end

post '/hikers/:id' do
  hiker = Hiker.new(params)
  hiker.update
  redirect to "/hikers/#{params['id']}"
end

post 'hikers/:id/new-hike' do

end

post '/hikers/:id/delete' do
  hiker = Hiker.find_by_id(params[:id])
  hiker.delete()
  redirect to("/hikers")
end

post '/hikers/:id/new-hike' do
  if params['date'] == ""
    redirect to("/hikers/#{params['id']}/new-hike/error")
  else
    hike = Hike.new(params)
    hike.save
    hiker = Hiker.find_by_id(hike.hiker_id)
    if hiker.munro_goal == hiker.unique_hikes_no
      redirect to("/hikers/#{hiker.id}/goal_completed")
    else
      redirect to("/hikers/#{hiker.id}")
    end
  end
  redirect to "/hikers/#{params['id']}"
end

get '/hikers/:id/goal_completed' do
  @hiker = Hiker.find_by_id(params['id'])
  @hiker.munro_goal = nil
  @hiker.update()
  erb(:"hikers/goal_completed")
end
