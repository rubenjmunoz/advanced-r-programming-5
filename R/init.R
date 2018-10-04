#library(shiny)
#library(httr)
#library(jsonlite)
#library(shinythemes)
#library(ggplot2)
#library(yarrr)

source('R/server.R')
source('R/ui.R')

#' Start Kolada Shiny App
#'
#' @return Returns and start the Kolada Shiny App
#' @export
#'
startKoladaShiny = function() {
  shinyApp(ui = ui, server = server)
}
