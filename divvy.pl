#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use JSON qw( decode_json );

my $data = decode_json(get("http://divvybikes.com/stations/json"));
my $stations = $data->{"stationBeanList"};

foreach my $station(@$stations) {
	print "There are ".$station->{"availableDocks"}." of ".$station->{"totalDocks"}." docks available at ".$station->{"stationName"}."\n";
}

print "Last update: ".$data->{"executionTime"}."\n";
