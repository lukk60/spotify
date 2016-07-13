###########Script do download and safe Popularity-Info from Spotify API ################
##----------------------------------------------------------------------------------------------------------------

#setup
setwd("D:/Datascience/spotify")
library(readr)
library(dplyr)
library(httr)
library(lubridate)
library(jsonlite)
#----------------------------------connect to api-------------------------------------------
#load Client Info
api_info <- scan("api_info.txt", "character")
clientID <- api_info[2]
clientSecret <- api_info[4]

#authenticate function
auth.token <- function(ClientID, clientSecret){
  response = POST("https://accounts.spotify.com/api/token", 
                accept_json(),
                authenticate(clientID, clientSecret),
                body=list(grant_type="client_credentials"), 
                encode="form", 
                verbose()
  )

  mytoken <- content(response)$access_token
  return(mytoken)
}

#get token
auth <- paste0("Bearer ", auth.token(ClientID, clientSecret)

#baseurl               
baseurl <- "https://api.spotify.com/v1/"

#load artist ids
artists <- read_csv2("data/artists.csv")

#load country data
load("data/countries.rda")

#--------------------------------get top tracks for artists in countries
#load artist ids
artists$url <- paste0(baseurl, "artists/", artists$id, "/top-tracks?country=")

#create url list
urls <- expand.grid(artists$url, unique(country$ISO_Code))
urls <- paste0(urls$Var1, urls$Var2)

#source downloadfunctions
source("code/download_tt_functions.R")

#request top tracks
tt <- sapply(urls, FUN=spotify.get.tt, Authorization=auth)

#convert return object to data frame
tt <- lapply(tt, FUN=data.frame)
tt.na <- unlist(lapply(tt.df, FUN=function(x) dim(x)[1]>1)) #excluse countries with no info available
tt <- rbind_all(tt[tt.na])

#-------------------------------save data-------------------------------------
save(tt, file=paste0("data/toptracks/", gsub(":","-",now()), ".rda"))
