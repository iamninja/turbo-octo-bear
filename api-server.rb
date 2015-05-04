require 'rubygems'
require 'sinatra'
require 'json'


set :port, 4567
set :enviroment, :production

get '/' do
	"Hello World!".to_json
end

get '/api/vodafone/:name' do
	response = Hash.new
	response[:Hello] = 'world!!'
	response.to_json
end
