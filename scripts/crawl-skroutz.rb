require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'json'

HEADER_HASH	= { 'User-Agent' => 'Ruby/#{RUBY_VERSION}' }
DATA_SKROUTZ_DIR = "data/skroutz"
FileUtils.mkdir_p(DATA_SKROUTZ_DIR) unless File.exists?(DATA_SKROUTZ_DIR)

def fetch_skroutz_data

	hashedData = Hash.new
	url_list = Array.new
	# Read links from file
	File.open("./scripts/skroutz-product-list.txt", "r").each do |line|
		url_list.push(URI.parse(URI.encode(line.strip)))
	end

	id = 1
	url_list.each do |url|
		print "Fetching data..."
		page = Nokogiri::HTML(open(url, HEADER_HASH))
		product_name = page.css('title').text.slice(/.+?(?=\|)/).strip
		lowest_price = page.css('a.price_link')[0].text

		hashedData[id] = {:product_name => product_name, :lowest_price => lowest_price}
		print "\r"
		# print "#{product_name}: #{lowest_price}\n"
		puts hashedData
		id = id + 1
	end

	File.open("./#{DATA_SKROUTZ_DIR}/products.json", 'w') do |file|
		file.puts hashedData.to_json
	end
end