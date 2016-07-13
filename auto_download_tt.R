# Script that can be called by Task Scheduler to download top track data 
#---------------------------------Setup Workspace------------------------------
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
tt <- sapply(urls, FUN=spotify.get.tt, Authorization=auth)
tt <- lapply(tt, FUN=data.frame)
tt.na <- unlist(lapply(tt.df, FUN=function(x) dim(x)[1]>1)) #excluse countries with no info available
tt <- rbind_all(tt[tt.na])

#---------------------------------save file-------------------------------------
save(tt, file=paste0("data/toptracks/", gsub(":","-",now()), ".rda"))
