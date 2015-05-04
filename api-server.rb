require 'rubygems'
require 'sinatra'
require 'json'

require './crawl-vodafone-gr'


set :port, 4567
set :enviroment, :production

get '/' do
	"Hello World!".to_json
end

get '/api/vodafone/:name' do
	if params[:name] == "vagios"
		fetch_vodafone_data
	else
		puts "Not known user"
	end
end
