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
#' @return Returns and strts the Kolada Shiny App
#' @export
#'
#' @examples
startKoladaShiny = function() {
  shinyApp(ui = ui, server = server)
}
