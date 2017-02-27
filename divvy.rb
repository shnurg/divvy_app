require 'open-uri'
require 'json'

# using Haversine formula to calculate distances.
# http://en.wikipedia.org/wiki/Haversine_formula
# http://www.esawdust.com/blog/gps/files/HaversineFormulaInRuby.html
def haversine_miles(lat1,lng1,lat2,lng2)
	rad_per_deg = Math::PI / 180
	earth_radius_miles = 3963.1676
	lat1_rad = lat1*rad_per_deg
	lat2_rad = lat2*rad_per_deg
	dlat_rad = (lat1-lat2)*rad_per_deg
	dlng_rad = (lng1-lng2)*rad_per_deg
	a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlng_rad/2))**2
	c = 2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a))
	d = c*earth_radius_miles
	return d
end

print "Please enter your location address: "
loc = gets.chomp.gsub(" ","+")
print "Please enter station search radius in miles: "
radius = gets.chomp.to_f

loc_data = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{loc}&sensor=true").read)
my_lat = loc_data["results"][0]["geometry"]["location"]["lat"].to_f
my_lon = loc_data["results"][0]["geometry"]["location"]["lng"].to_f

sta_data = JSON.parse(open("http://divvybikes.com/stations/json").read)
a = Array.new
sta_data["stationBeanList"].each do |station|
	station_lat = station["latitude"]
	station_lng = station["longitude"]
	d = haversine_miles(my_lat,my_lon,station_lat,station_lng)
	if d < radius
		a.push({:name => station["stationName"], :bikes => station["totalDocks"].to_i-station["availableDocks"].to_i, :docks => station["totalDocks"].to_i, :dist => d})
	end
end

if a.size > 1
	a = a.sort_by {|x| x[:dist]}
	puts "Closest stations within #{radius} miles as of #{sta_data["executionTime"]}:"
	a.each do |station|
		puts "#{station[:name]}: #{station[:bikes]}/#{station[:docks]} bikes, #{'%.2f' % station[:dist]} miles away."
	end
else 
	puts "No stations found within #{radius} miles."
end
