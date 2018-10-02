library(shiny)
library(shinythemes)
library(ggplot2)
library(httr)
library(jsonlite)
library(yarrr)
source('webService.R')

shinyUI(fluidPage( theme = shinytheme("slate"), fluidRow(column(
  12,
  h1("Kola database", align = "center"),
  h3("KPI comparison of two municipalities", align = "center"),
  hr(),
  fluidRow(
    column(
      6,
      
      wellPanel(
        h4(" 1. Select Parameters"),
        hr(),
        column(6,
               uiOutput("municipalityDropDownListLeft")),
        column(6,
               uiOutput("kpiDropDownListLeft")),
        sliderInput(
          "yearDropDownListLeft",
          label = "Year Range",
          min = 1980,
          max = 2017,
          value = c(1992, 2004),
          width = "100%"
        ),
        fluidRow( align = "center",
          actionButton(
            inputId = "PlotButtonLeft",
            label = "2. Plot dat shit!"
          )
        )
      ),
      fluidRow(plotOutput("Barplot_Left"))
      
    ),
    column(
      6,
      wellPanel(
        h4(" 1. Select Parameters"),
        hr(),
        column(6,
               uiOutput("municipalityDropDownListRight")),
        column(6,
               uiOutput("kpiDropDownListRight")),
        sliderInput(
          "yearDropDownListRight",
          label = "Year Range",
          min = 1980,
          max = 2017,
          value = c(1992, 2004),
          width = "100%"
        ),
        fluidRow( align = "center",
                  actionButton(
                    inputId = "PlotButtonRight",
                    label = "2. Plot dat shit!"
                  )
        )
      ),
      fluidRow(plotOutput("Barplot_Right"))
    )
  )
))))