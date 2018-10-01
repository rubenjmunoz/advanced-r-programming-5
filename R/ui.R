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
                               uiOutput("kpiDropDownListLeft"))
                        # ,
                        # column(4,
                        #        #uiOutput("yearDropDownListLeft"))
                        #        sliderInput("yearDropDownListLeft", label = h3("Year Range"), min = 1980, 
                        #                    max = 2017, value = c(2012, 2012))
                        # )
                        
                      ),
                      sliderInput("yearDropDownListLeft", label = h3("Year Range"), min = 1980, 
                                  max = 2017, value = c(1992, 2004), width = "100%"),
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