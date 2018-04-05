require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/munro.rb')

get '/munros' do
  @munros = Munro.all()
  @most_popular = Munro.most_popular()
  @most_indiv_visits = Munro.most_indiv_visits()
  erb (:"munros/index")
end

get '/munros/new' do
  erb(:"munros/new")
end

post '/munros' do
  munro = Munro.new(params)
  munro.save
  redirect to("/munros")
end

get '/munros/:id' do
  @munro = Munro.find_by_id(params['id'].to_i)
  @successful_hikers = @munro.all_hikers()
  erb( :"munros/show" )
end

get '/munros/:id/edit' do
  @munro = Munro.find_by_id(params['id'])
  erb(:"munros/edit")
end

post '/munros/:id' do
  munro = Munro.new(params)
  munro.update
  redirect to "/munros/#{params['id']}"
end

post '/munros/:id/delete' do
  munro = Munro.find_by_id(params[:id])
  munro.delete()
  redirect to("/munros")
end
