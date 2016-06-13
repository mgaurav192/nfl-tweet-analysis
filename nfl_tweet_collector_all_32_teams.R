#!/usr/bin/env Rscript

# Created on Tue Nov  10 20:48:36 2015
# @author: mgaurav
# R script to harvest tweets containing mentions of NFL related hashtags using R streaming API which use Twitter's streaming API

library("stringr")
library("twitteR")
library("ROAuth")
library("RCurl")
library("bitops")
library("rjson")
library("streamR")

# load your own twitter authorization file in R format
load("/home/grad3/mgaurav/cs688/R/authorization_files/my_oauth_texans.Rdata")


testString = readLines("/home/grad3/mgaurav/cs688/R/hashtags/32teams.nfl.hashtags")
print (testString)
current_date = as.Date(Sys.Date(), "%m/%d/%Y")

# collect all tweets and save it in Json file separately for each day 
filterStream(paste("/home/grad3/mgaurav/cs688/R/daily_json_tweet_collection/",current_date,".json",sep=""), track = testString, timeout = 700, oauth = my_oauth)
