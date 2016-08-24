# Script that can be called by Task Scheduler to download top track data 
#---------------------------------Setup Workspace------------------------------
cat("Start Script:", date())
setwd("D:/Datascience/spotify")

library(readr)
library(dplyr)
library(httr)
library(lubridate)
library(jsonlite)

source("code/auth.spotify.R")
source("code/download_tt_functions.R")

#---------------------------------Load files and authenticate with api----------
auth <- auth.spotify("api_info.txt")
load("data/urls.rda")

#---------------------------------Request data and extract information----------
tt <- lapply(urls, FUN=spotify.get.tt, Authorization=auth)
tt <- lapply(tt, FUN=data.frame)
tt.na <- unlist(lapply(tt, FUN=function(x) dim(x)[1]>1)) #exclude countries with no info available
table(tt.na)

tt <- rbind_all(tt[tt.na])

#---------------------------------save file-------------------------------------
write.csv(tt, file=paste0("data/toptracks/", gsub(":","-",now()), ".csv"), row.names = F)

#clean up
rm(list=ls())

cat("End Script:", date())
