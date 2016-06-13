#!/usr/bin/env Rscript

# create_all_user_table.R
# For every json file passed as an imput argument, computes an output in format - tweet_id\ttweet_usr_id\tuser_name\tscreen_name\thashtags 

library("stringr")
library("twitteR")
library("ROAuth")
library("RCurl")
library("bitops")
library("rjson")
library("streamR")

tweets.list <- readTweets("/home/grad3/mgaurav/cs688/R/json_files_20151216_010000/all_cowboys_patriots.json")

twt.text <- c()
twt.id <- c()
twt.usrid <- c()
twt.hashtag <- c()
twt.usrname <- c()
twt.screenname <- c()
for (i in 1:length(tweets.list)){
  twt.text[i] <- tweets.list[[i]]['text']
  twt.id[i] <- tweets.list[[i]]['id']
  twt.usrid[i] <- tweets.list[[i]]$user$id
  twt.usrname[i] <- gsub("\t|\r|\n", " ", tweets.list[[i]]$user$name, fixed = FALSE)
  twt.screenname[i] <- gsub("\t|\r|\n", " ", tweets.list[[i]]$user$screen_name, fixed = FALSE)
  twt.hashtag[i] <- ""
  if ( length(tweets.list[[i]]$entities$hashtags) != 0) {
    tags <- sapply(tweets.list[[i]]$entities$hashtags,  "[", "text")
    tags_text <- paste(tags,sep = " ")
    #print(toString(tags_text))
    twt.hashtag[i] <- toString(tags_text)
  }
  if ( length(tweets.list[[i]]$retweeted_status$entities$hashtags) != 0) {
    tags <- sapply(tweets.list[[i]]$retweeted_status$entities$hashtags,  "[", "text")
    tags_text <- paste(tags,sep = " ")
    if (is.na(twt.hashtag[i]))
    {
      twt.hashtag[i] <- toString(tags_text)
    }
    else
    {
      
      twt.hashtag[i] <- c(twt.hashtag[i],toString(tags_text))
    }
  }
  if ( length(tweets.list[[i]]$retweeted_status$quoted_status$entities$hashtags) != 0) {
    tags <- sapply(tweets.list[[i]]$retweeted_status$quoted_status$entities$hashtags,  "[", "text")
    tags_text <- paste(tags,sep = " ")
    if (length(twt.hashtag[i]) == 0 )
    {
      twt.hashtag[i] <- toString(tags_text)
    }
    else
    {
      twt.hashtag[i] <- c(twt.hashtag[i],toString(tags_text))
    }
  }
  if ( length(tweets.list[[i]]$quoted_status$entities$hashtags) != 0) {
    tags <- sapply(tweets.list[[i]]$quoted_status$entities$hashtags,  "[", "text")
    tags_text <- paste(tags,sep = " ")
    if (!is.na(twt.hashtag[i]))
    {
      twt.hashtag[i] <- toString(tags_text)
    }
    else
    {
      print(twt.hashtag[i])
      print (twt.screenname[i])
      twt.hashtag[i] <- c(twt.hashtag[i],toString(tags_text))
    }
  }
  line = paste(twt.id[i],twt.usrid[i],twt.usrname[i],twt.screenname[i],gsub("\t|\r|\n", " ", toString(twt.hashtag[i]), fixed = FALSE),sep = "\t")
  write(line,file="/home/grad3/mgaurav/cs688/R/json_files_20151216_010000/all_cowboys_patriots.json.geoloc",append=TRUE)#"C:/work/cs688/json_summary_all.txt",append=TRUE)
}
