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
                        actionButton(inputId = "PlotButtonLeft", label = "Plot dat shit!")
                      ),
                      fluidRow(
                        plotOutput("Barplot_Left")
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
                        actionButton(inputId = "PlotButtonRight", label = "Plot dat shit!")
                      ),
                      fluidRow(
                        plotOutput("Barplot_Right")
                      )
               )
             )
      )
    )
  )
)
