#Authenticate with spotify api and get access token

auth.spotify <- function(api_credentials="api_info.txt") {
  
  api_info <- scan(api_credentials, "character")
  clientID <- api_info[2]
  clientSecret <- api_info[4]
  
  response = POST("https://accounts.spotify.com/api/token", 
                  accept_json(),
                  authenticate(clientID, clientSecret),
                  body=list(grant_type="client_credentials"), 
                  encode="form", 
                  verbose()
  )
  
  mytoken <- content(response)$access_token
  auth <- paste0("Bearer ", mytoken)
  return(auth)
}
