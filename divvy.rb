require 'open-uri'
require 'json'

data = JSON.parse(open("http://divvybikes.com/stations/json").read)

data["stationBeanList"].each do |station|
	puts "There are #{station["availableDocks"]} of #{station["totalDocks"]} docks available at #{station["stationName"]}"
end

puts "Last update: #{data["executionTime"]}"
