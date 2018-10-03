#library(shiny)
#library(httr)
#library(jsonlite)
#library(shinythemes)
#library(ggplot2)
#library(yarrr)

source('R/server.R')
source('R/ui.R')

shinyApp(ui = ui, server = server)