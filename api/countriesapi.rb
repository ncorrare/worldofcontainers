#Extremely Simple API with three basic verbs. 
require 'sinatra'
require 'mysql2'
require 'json'
require 'rest-client'
require 'memcached'
require 'yaml'

set :bind, '0.0.0.0'

begin
	CONFIG = YAML.load_file("/config/config.yaml") unless defined? CONFIG
	con = Mysql2::Client.new(:host => CONFIG['db']['host'], :username => CONFIG['db']['user'], :password => CONFIG['db']['password'], :database => CONFIG['db']['name'])
	cache = Memcached.new("#{CONFIG['memcache']['host']}")
	# HTTP GET verb to retrieve a specific city. Returns 404 if item is not present.
	get '/countries/:country/cities/:city' do 
		sql = "SELECT * FROM location WHERE country=\"#{params['country']}\" and city=\"#{params['city']}\""
		puts sql
		rs = con.query(sql)
		rowcount = rs.count
		unless rowcount == 0
			row = rs.each
			content_type :json
			city = { 'latitude' => row.first['latitude'], 'longitude' => row.first['longitude'], 'altitude' => row.first['altitude'] }
			result = { row.first['city'] => city, 'total' => rowcount }  
			json=JSON.pretty_generate(result)
			"#{json}"

		else
			status 404
			"City not found"
		end
	end


	# HTTP GET verb to retrieve a specific item. Returns 404 if item is not present.
	get '/cc/:country/cities' do 
		sql = "SELECT * FROM location WHERE cc = \"#{params['country']}\""
		puts sql
		rs = con.query(sql)
		rowcount = rs.count
		unless rowcount == 0
			content_type :json
			cities = Array.new
			rs.each do |row|
				city = { 'name' => row['city'], 'latitude' => row['latitude'], 'longitude' => row['longitude'], 'altitude' => row['altitude'] } 
				cities << city
			end
			json=JSON.pretty_generate(cities)
			"#{json}"
		else
			status 404
			"Country not found"
		end

	end
	# HTTP GET verb to retrieve a specific item. Returns 404 if item is not present.
	get '/countries/:country/cities' do 
		sql = "SELECT * FROM location WHERE country = \"#{params['country']}\""
		puts sql
		rs = con.query(sql)
		rowcount = rs.count
		unless rowcount == 0
			content_type :json
			cities = Array.new
			rs.each do |row|
				city = { row['city'] => { 'latitude' => row['latitude'], 'longitude' => row['longitude'], 'altitude' => row['altitude'] } }
				cities << city
			end
			result = { "cities" => cities, "total" => rowcount }  
			json=JSON.pretty_generate(result)
			"#{json}"
		else
			status 404
			"Country not found"
		end

	end

	# HTTP GET verb to retrieve a specific item. Returns 404 if item is not present.
	get '/cc/:country/info' do 
		content_type :json
		begin
			info = cache.get params['country']
			result = { "capital" => info['capital'], "pop" => info['pop'], "status" => "Cached" }
			"result"
		rescue Memcached::Error

			response = RestClient.get "https://restcountries.eu/rest/v1/alpha?codes=#{params['country']}"
			info = JSON.parse(response)

		#cities = Array.new
		#rs.each do |row|
		#	city = { row['city'] => { 'latitude' => row['latitude'], 'longitude' => row['longitude'], 'altitude' => row['altitude'] } }
		#	cities << city
		#end
			result = { "capital" => info.first['capital'], "pop" => info.first['population'], "status" => "Retrieved" }  
			cache.set params['country'], result
		end
		json=JSON.pretty_generate(result)
		"#{json}"

	end


	# HTTP GET verb to retrieve all the items.
	get '/countries' do
		sql = "SELECT DISTINCT country FROM location"
		puts sql
		rs = con.query(sql)
		rowcount = rs.count
		unless rowcount == 0
			content_type :json
			countries = Array.new
			rs.each do |row|
				countries << row['country']
			end
			result = { "countries" => countries, "total" => rowcount }  
			json=JSON.pretty_generate(result)
			"#{json}"
		else
			status 404
			"Country not found"
		end
	end

rescue Mysql2::Error => e
	puts e.errno
	puts e.error

end
