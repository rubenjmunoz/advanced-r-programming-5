library(httr)
library(jsonlite)
library(plyr)

# Example URLS
# Example URL: http://api.kolada.se/v1/ou/data/peryear/N15030/2011?page=2&per_page=100
# http://api.kolada.se/v2/data/kpi/U21401,U21468,U23401,U23471,U31402,U33400/municipality/1283/year/2013

# Baisc Data
base = "http://api.kolada.se/"
api_version = "v2/"

fetchMunicipalities = function() {
  endpoint = "municipality"
  webCall = paste(base, api_version, endpoint, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Deserialization
  result = fromJSON(content(response, "text", encoding = "utf-8"), flatten = TRUE)
  
  return(as.data.frame(result))
}

fetchKpis = function() {
  endpoint = "kpi_groups"
  webCall = paste(base, api_version, endpoint, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Deserialization
  result = fromJSON(content(response, "text", encoding = "utf-8"), flatten = FALSE)
  
  # Check Server Response
  if (response["status_code"] < 200 | response["status_code"] > 299) stop("HTTP Stauts code it not OK (not in range 200-299).")
  
  # Prepare Data Frames
  kpi.group.data.frame = as.data.frame(result)
  kpi.data.frame = data.frame(member_id = integer(), member_title = character())
  
  # Extract required data
  for (i in 1:nrow(kpi.group.data.frame)) {
    group_kpi = kpi.group.data.frame[i, 3][[1]]
    kpi.data.frame = rbind(kpi.data.frame, group_kpi)
    data.frame[nrow(kpi.data.frame) + 1,] = list(kpi.group.data.frame[], kpi.group.data.frame[])
  }
  return(kpi.data.frame)
}

fetchData = function(kpi, municipality, year) {
  endpoint = "/ou/data/peryear/N15030/2011"
  page = 1
  per_page = 100 # Is max for this API
  webCall = paste(base, api_version, endpoint, "?", "page=", page, "&per_page=", per_page, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Deserialization
  result.data.frame = data.frame()
  
  repeat {
    webCall = paste(base, endpoint, "?", "page=", page, "&per_page=", per_page, sep="")
    
    # Execution
    response = GET(webCall)
    
    # Deserialization
    result = fromJSON(content(response, "text"), flatten = FALSE)
    
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
}

x = fetchMunicipalities()
a = 5
