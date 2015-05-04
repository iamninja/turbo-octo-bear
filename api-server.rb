require 'rubygems'
require 'sinatra'
require 'json'
require 'rufus/scheduler'

require './crawl-vodafone-gr'

# Scheduling tasks
scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
	fetch_vodafone_data
end

	# Set options
	set :port, 4567
set :enviroment, :production

get '/' do
	"Hello World!".to_json
end

get '/api/vodafone/:username' do
	responseBalance = Hash.new
	if File.exists?("./#{DATA_DIR}/#{params[:username]}.json")
		file = File.read("./#{DATA_DIR}/#{USERNAME}.json")
		responseBalance = JSON.parse(file)
		responseBalance.to_json
	else
		puts "Not known user"
		{:error => "Not know user: #{params[:username]}"}.to_json
	end
end
