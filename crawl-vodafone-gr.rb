require "rubygems"
require "nokogiri"
require "mechanize"
require "json"
require "./credentials"

LOGIN_URL = "https://www.vodafone.gr/portal/client/idm/loginForm.action?null"
PROFILE_URL = "https://www.vodafone.gr/portal/client/idm/loadPrepayUserProfile.action?scrollanchor=0"

# USERNAME = ""
# PASSWORD = ""

def fetch_vodafone_data
	responseData = Hash.new
	browser = Mechanize.new { |agent|
		agent.user_agent_alias = "Mac Safari"
	}

	browser.get(LOGIN_URL) do |page|
		puts page.uri
		puts page.title
		puts page.at('h1').text.strip
		puts "Logging in as #{USERNAME}..."
		form = page.forms.first

		form['username'] = USERNAME
		form['password'] = PASSWORD
		logged_page = form.submit
		logged_page.encoding = 'utf-8'
		puts "...logged in"

		# Retrive user profile
		phoneNumber = logged_page.at('div.ppMyProfileTitle span').text
		balanceEuro = logged_page.at('div.firstRow2').text.strip.to_i
		balanceCents = logged_page.at('div.firstRow2 span').text.strip

		puts "Phone number: #{phoneNumber}"
		moneyBalance = "#{balanceEuro}.#{balanceCents}".to_f

		# Retrieve balance info
		balances = logged_page.search('.table-sort td.toggler .cc-remaining')
		dataBalanceArray = Array.new
		balances.each do |node|
			if node.content.include? 'MB'
				dataBalanceArray << node.first_element_child.text.strip.to_i
			end
		end
		dataBalance = dataBalanceArray.inject(0, :+)

		hashedData = {"username" => USERNAME,
					"phone" => phoneNumber,
					"moneyBalance" => moneyBalance,
					"mb" => dataBalance}

		responseData = hashedData.to_json
		puts responseData
	end
	responseData
end