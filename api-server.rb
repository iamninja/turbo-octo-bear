require 'sinatra'
require 'json'


set :port, 4567
set :enviroment, :production

get '/' do
	"Hello World!".to_json
end