library(shiny)
library(ggplot2)
library(httr)
library(jsonlite)
source('webService.R')

shinyUI(
  fluidPage(
    fluidRow(
      column(12,
             "Comparison of two plots",
             fluidRow(
               column(6,
                      " Select Input",
                      fluidRow(
                        column(4, 
                               "Dropdown Input 1",
                               uiOutput("municipalityDropDownList")
                        ),
                        column(4,
                               "Dropdown Input 2"),
                        column(4,
                               "Dropdown Input 3")
                      ),
                      fluidRow(
                        plotOutput("Barplot_1")
                      )
               ),
               column(6,
                      " Select Input",
                      fluidRow(
                        column(4, 
                               "Dropdown Input 1"),
                        column(4,
                               "Dropdown Input 2"),
                        column(4,
                               "Dropdown Input 3")
                      ),
                      fluidRow(
                        plotOutput("Barplot 2")
                      )
               )
             )
      )
    )
  )
)
