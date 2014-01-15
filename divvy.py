import urllib2
import json

data = json.load(urllib2.urlopen("http://divvybikes.com/stations/json"))

for station in data["stationBeanList"]:
	print "There are " + str(station["availableDocks"]) + " of " + str(station["totalDocks"]) + " docks available at " + station["stationName"]

print "Last update: " + data["executionTime"]
