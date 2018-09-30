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
                               uiOutput("municipalityDropDownListLeft")
                        ),
                        column(4,
                               uiOutput("kpiDropDownListLeft")),
                        column(4,
                               uiOutput("yearDropDownListLeft"))
                      ),
                      fluidRow(
                        plotOutput("Barplot_1")
                      )
               ),
               column(6,
                      " Select Input",
                      fluidRow(
                        column(4, 
                               uiOutput("municipalityDropDownListRight")
                        ),
                        column(4,
                               uiOutput("kpiDropDownListRight")),
                        column(4,
                               uiOutput("yearDropDownListRight"))
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
