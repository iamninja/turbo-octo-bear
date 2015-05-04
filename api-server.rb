require 'rubygems'
require 'sinatra'
require 'json'
require 'rufus/scheduler'

require './scripts/crawl-vodafone-gr'
require './scripts/crawl-skroutz'

# Scheduling tasks
scheduler = Rufus::Scheduler.new

scheduler.every '10m' do
	fetch_vodafone_data
end
scheduler.every '30m' do
	fetch_skroutz_data
end

# Initialize data
# fetch_skroutz_data
# fetch_vodafone_data

# Set options
set :port, 4567
set :enviroment, :production

get '/' do
	"Hello World!".to_json
end

get '/api/vodafone/:username' do
	responseBalance = Hash.new
	if File.exists?("./#{DATA_VODAFONE_DIR}/#{params[:username]}.json")
		file = File.read("./#{DATA_VODAFONE_DIR}/#{USERNAME}.json")
		responseBalance = JSON.parse(file)
		responseBalance.to_json
	else
		puts "Not known user"
		{:error => "Not know user: #{params[:username]}"}.to_json
	end
end

get '/api/skroutz' do
	responseProducts = Hash.new
	file = File.read("./#{DATA_SKROUTZ_DIR}/products.json")
	responseProducts = JSON.parse(file)
	responseProducts.to_json
end