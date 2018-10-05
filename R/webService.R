# Basic Data
base = "http://api.kolada.se/"
api_version = "v2/"

#' Fetch Municipalities
#'
#' @return Returns a data.frame containing all municipalities.
#' @export
#'
fetchMunicipalities = function() {
  endpoint = "municipality"
  webCall = paste(base, api_version, endpoint, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Check Server Response
  if (response["status_code"] < 200 | response["status_code"] > 299) stop("HTTP Stauts code it not OK (not in range 200-299).")
  
  # Deserialization
  result = fromJSON(content(response, "text", encoding = "utf-8"), flatten = TRUE)
  
  return(as.data.frame(result))
}

#' Fetch KPIs
#'
#' @return Returns a data.frame containing all KPIs with their id and description.
#' @export
#'
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
  }
  return(kpi.data.frame)
}

#' Fetch By Municipality
#'
#' @param municipality Id of the municipality.
#' @param year The year as integer.
#'
#' @return Returns a data.frame containing all KPIs belonging to the municipality in the given year.
#' @export
#'
fetchByMunicipality = function(municipality, year){
  #http://api.kolada.se/v2/data/municipality/1860/year/2009
  
  if (length(municipality) > 1 | !is.numeric(municipality)) stop("municipality parameter must be a numeric scalar.")
  if (!is.numeric(year) | length(year) > 1) stop("year must be numeric and must have a length of 1")
  
  endpoint = "data/municipality/"
  
  webCall = paste(base, api_version, endpoint, municipality, "/year/", year, sep="")
  
  # Execution
  response = GET(webCall)
  
  # Check Server Response
  if (response["status_code"] < 200 | response["status_code"] > 299) stop("HTTP Stauts code it not OK (not in range 200-299).")
  
  # Deserialization
  result = fromJSON(content(response, "text"), flatten = TRUE)
  return(as.data.frame(result))
}

#' Fetch By KPI
#'
#' @param kpi Id of the KPIs as a list.
#' @param municipality Id of the municipality.
#' @param year The years to fetch as a list.
#'
#' @return Returns a data.frame containing the requested data
#' @export
#'
fetchByKpi = function(kpi, municipality , year = list()) {
  
  if (any(grepl("[,]", kpi) == TRUE)) stop("character ',' is not allowed for kpis")
  if (length(kpi) == 0) stop("kpi contains no entries")
  if (!is.list(kpi)) stop("kpi must be a list")
  if (!is.list(year)) stop("year is not a list")
  
  endpoint = "data/kpi/"

  webCall = paste(base, api_version, endpoint, sep="")
  
  for (i in 1:length(kpi)) {
    webCall = paste(webCall, kpi[i], sep="")
    if (i != length(kpi)) webCall = paste(webCall, ",", sep="")
  }
  
  webCall = paste (webCall, "/municipality/", municipality, sep="")

  if (length(year) > 0) {
    webCall = paste(webCall, "/year/", sep="")
    
    for (j in 1:length(year)) {
      webCall = paste(webCall, year[j], sep="")
      if (j != length(year)) webCall = paste(webCall, ",", sep="")
    }
  }
  
  # Execution
  response = GET(webCall)

  # Check Server Response
  if (response["status_code"] < 200 | response["status_code"] > 299) stop("HTTP Stauts code it not OK (not in range 200-299).")
  
  # Deserialization
  result = fromJSON(content(response, "text"), flatten = TRUE)
  if (result["count"] == 0) return(data.frame())
  return(as.data.frame(result))
}

#a = fetchMunicipalities()
#b = fetchKpis()
#c = fetchByKpi(list("N00914", "U00405"), 1440, list(2010, 2011, 2012))
#d = fetchByMunicipality(1440, 2012)
