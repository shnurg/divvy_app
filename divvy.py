import urllib2
import json

json_data = urllib2.urlopen("http://divvybikes.com/stations/json")
data = json.load(json_data)

stations = data["stationBeanList"]

for station in stations:
	loc = station["stationName"]
	ava = station["availableDocks"]
	print "There are " + str(ava) + " docks available at " + loc