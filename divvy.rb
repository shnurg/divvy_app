require 'open-uri'
require 'json'

divvy_json = open("http://divvybikes.com/stations/json").read
divvy = JSON.parse(divvy_json)

stations = divvy["stationBeanList"]

stations.each do |station|
	puts "#{station["availableDocks"]} docks available at #{station["stationName"]}"
end