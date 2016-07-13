#define download-functions

#download function
spotify.get <- function(url, Authorization){
  args <- list(url=url, config=add_headers(Authorization=Authorization))
  out <- do.call(GET, args=args)
  return(out)
}

#download top-track function
spotify.get.tt <- function(url, Authorization){
  tt <- spotify.get(url=url, Authorization=Authorization)
  
  #return NA if status is not 200 (i.e. request was not successfull)
  if(tt$status_code != 200){ 
    warning(content(tt)$error$message)
    return(NA)
  } else {
    
    #extract popularity and track information
    tt <- content(tt)
    tt <- tt$tracks
    
    out <- data_frame(
      date = now(),
      track.name = unlist(lapply(tt, FUN=function(x){x$name})),
      track.uri = unlist(lapply(tt, FUN=function(x){x$uri})),
      popularity = unlist(lapply(tt, FUN=function(x){x$popularity}))
    )
    
    #add artist info
    out$artist.name <- rep(tt[[1]]$artists[[1]]$name, nrow(out))
    out$artist.uri <- rep(tt[[1]]$artists[[1]]$uri, nrow(out))
    
    #add country info
    out$country <- rep(substr(url, nchar(url)-1, nchar(url)), nrow(out))
    
    #return data frame
    cat("Download successfull: ", out[1,c(1,5,7)], "\n")
    return(out)
  }
}
