library(httr)
library(jsonlite)
library(plyr)

# Prepare Call
# Example URL: http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=1000
base = "http://api.kolada.se/"
endpoint = "v1/ou/data/peryear/N15030/2011"
page = 1
per_page = "100" # Is max for this API
webCall = paste(base, endpoint, "?", "page=", page, "&per_page=", per_page, sep="")

# Execution
response = GET(webCall)

# Deserialization
result.data.frame = data.frame()

repeat {
  webCall = paste(base, endpoint, "?", "page=", page, "&per_page=", per_page, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Deserialization
  result = fromJSON(content(response, "text"), flatten = TRUE)
  
  # Check Server Response
  if (response["status_code"] < 200 | response["status_code"] > 299) stop("HTTP Stauts code it not OK (not in range 200-299).")
  
  # Combine data.frames
  attaching.data.frame = as.data.frame(result)
  result.data.frame = rbind.fill(result.data.frame, attaching.data.frame)
  
  # Check if there is more data
  if (!"next" %in% names(result)) break
  
  # Increase paging
  page = page + 1
}
