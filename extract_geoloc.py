#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Created on Tue Nov  15 20:48:36 2015
# @author: mgaurav
# R script to compute geolocation of all tweets contained in a Json file (input argument) per tweet. computes state and country for each tweet otherwise producess null for a given tweet ID
#

import json
import carmen
import sys

# ending in utf-8 necessary to avoid - UnicodeEncodeError: 'ascii' codec can't encode character u'\xed' in position 7: ordinal not in range(128)
print "tweet_id\tuser_id\tcountry\tstate"
with open(sys.argv[1]) as f:
  for line in f:
    tweet = json.loads(line)
    resolver = carmen.get_resolver()
    resolver.load_locations()
    location = resolver.resolve_tweet(tweet)
    #print "tweet_id\tuser_id\tcountry\tstate"
    if location:
      if location[1].state:
        print tweet["id"], "\t", tweet["user"]["id"], "\t", location[1].country.encode('utf-8'), "\t", location[1].state.encode('utf-8')  #"tweet id is ", tweet["id"], " and country is ", location[1].country, " and state is ", location[1].state
      else: 
        print tweet["id"], "\t", tweet["user"]["id"], "\t", "null", "\t", "null"
    else:
      print tweet["id"], "\t", tweet["user"]["id"], "\t", "null", "\t", "null"
