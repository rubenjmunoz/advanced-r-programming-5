#library(shiny)
#library(httr)
#library(jsonlite)
#library(shinythemes)
#library(ggplot2)
#library(yarrr)

require(shiny)
require(shinythemes)
require(httr)
require(jsonlite)
require(plyr)
require(ggplot2)
require(yarrr)

#source('webService.R')

# Call the recover function when an error occurs
options(error = recover)

server = function(input, output) {
  municipalitiesDataFrame = fetchMunicipalities()
  kpisDataFrame = fetchKpis()
  yearsAsVector = c(1980:2018)
  
  
  # Municipality Dropdown Left
  output$municipalityDropDownListLeft = renderUI({
    selectInput(
      inputId = "municipalityDropDownListLeft",
      choices = as.matrix(municipalitiesDataFrame["values.title"]),
      label = "Select Municipality:"
    )
  })
  
  # Municipality Dropdown Right
  output$municipalityDropDownListRight = renderUI({
    selectInput(
      inputId = "municipalityDropDownListRight",
      choices = as.matrix(municipalitiesDataFrame["values.title"]),
      label = "Select Municipality:"
    )
  })
  
  # Kpi Dropdown Left
  output$kpiDropDownListLeft = renderUI({
    selectInput(
      inputId = "kpiDropDownListLeft",
      choices = as.matrix(kpisDataFrame["member_id"]),
      label = "Select KPI:"
    )
  })
  
  # Kpi Dropdown Right
  output$kpiDropDownListRight = renderUI({
    selectInput(
      inputId = "kpiDropDownListRight",
      choices = as.matrix(kpisDataFrame["member_id"]),
      label = "Select KPI:"
    )
  })
  
  observeEvent(input$PlotButtonLeft, {
    # Left Panel
    municipalityDropDownListLeftHolder = as.character(input$municipalityDropDownListLeft)
    kpiDropDownListLeftHolder = as.character(input$kpiDropDownListLeft)
    #print(municipalityDropDownListLeftHolder)
    #print(kpiDropDownListLeftHolder)
    
    municipalityDropDownListLeftId = as.matrix(municipalitiesDataFrame["values.id"])[match(
      as.character(input$municipalityDropDownListLeft),
      as.matrix(municipalitiesDataFrame["values.title"])
    )]
    
    yearMin <- as.numeric(input$yearDropDownListLeft)[1]
    yearMax <- as.numeric(input$yearDropDownListLeft)[2]
    yearCnt <- as.numeric(input$yearDropDownListLeft)[1]
    
    kpiResultLeftVector <- c()
    while (yearCnt <= yearMax) {
      kpiResultLeft <-
        fetchByKpi(
          as.list(as.character(input$kpiDropDownListLeft)),
          municipalityDropDownListLeftId,
          as.list(yearCnt)
        )
      if (nrow(kpiResultLeft) == 0) {
        kpiResultLeftVector <- c(kpiResultLeftVector, 0)
      }
      else{
        content = kpiResultLeft[1, "values.values"]
        # Some times despite having some data in the row, the value we are looking for is not found and a NA is returned
        if (is.na(content[[1]][3, "value"])) {
          kpiResultLeftVector <-
            c(kpiResultLeftVector, 0)
        }
        else{
          kpiResultLeftVector <-
            c(kpiResultLeftVector, content[[1]][3, "value"])
        }
      }
      yearCnt <- yearCnt + 1
    }
    if (sum(kpiResultLeftVector) == 0) {
      # print no data message
      output$Barplot_Left = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
        plot(
          1,
          1,
          col.main = "lightgray",
          col.lab = "lightgray",
          col.axis = "lightgray",
          fg = "lightgray"
        )
        text(1, 1, "No data available:'( blame the government", col = "red")
      })
    }
    else{
      # plot the datarina
      names(kpiResultLeftVector) <- c(yearMin:yearMax)
      output$Barplot_Left = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
        par(mar = c(5,4,4.2,2), xpd = TRUE)
        barplot(
          kpiResultLeftVector,
          main = paste(as.character(municipalityDropDownListLeftHolder), as.character(kpiDropDownListLeftHolder), "KPI historical performance."),
          xlab = "Year",
          ylab = "KPI performance",
          cex.lab = 1.2,
          col = transparent(c(
            "springgreen2", "mediumaquamarine"
          ), trans.val = 0.8),
          col.main = "lightgray",
          col.lab = "lightgray",
          col.axis = "lightgray",
          fg = "lightgray",
          border = "lightgray",
          las = 3
        )
        abline(
          h = mean(kpiResultLeftVector[kpiResultLeftVector != 0]),
          lty = 2,
          lwd = 2,
          col = 'mediumpurple3'
        )
        abline(
          glm(kpiResultLeftVector[kpiResultLeftVector != 0] ~ c(1:length(
            kpiResultLeftVector[kpiResultLeftVector != 0]
          ))),
          lty = 2,
          lwd = 2,
          col = 'yellow3'
        )
        # Add legend
        legend(
          "bottomright",
          #inset=c(0.05, -0.2),
          legend = c("Median", "Linear trend"),
          col = c('mediumpurple3', 'yellow3'),
          bg = transparent(rgb(31.5, 38.6, 44.3, maxColorValue = 255), trans.val = 0.15),
          box.col = "lightgray",
          text.col = "lightgray",
          lty = 2,
          lwd = 2
        )
      })
    }
  })
  
  
  # observeEvent(input$PlotButtonRight, {
  #   # Right panel
  #   municipalityDropDownListRightId = as.matrix(municipalitiesDataFrame["values.id"])[match(
  #     as.character(input$municipalityDropDownListRight),
  #     as.matrix(municipalitiesDataFrame["values.title"])
  #   )]
  #   
  #   yearMin <- as.numeric(input$yearDropDownListRight)[1]
  #   yearMax <- as.numeric(input$yearDropDownListRight)[2]
  #   yearCnt <- as.numeric(input$yearDropDownListRight)[1]
  #   
  #   kpiResultRightVector <- c()
  #   
  #   while (yearCnt <= yearMax) {
  #     kpiResultRight <-
  #       fetchByKpi(
  #         as.character(input$kpiDropDownListRight),
  #         municipalityDropDownListRightId,
  #         yearCnt
  #       )
  #     if (nrow(kpiResultRight) == 0) {
  #       kpiResultRightVector <- c(kpiResultRightVector, 0)
  #     }
  #     else{
  #       content = kpiResultRight[1, "values.values"]
  #       # Some times despite having some data in the row, the value we are looking for is not found and a NA is returned
  #       if (is.na(content[[1]][3, "value"])) {
  #         kpiResultRightVector <-
  #           c(kpiResultRightVector, 0)
  #       }
  #       else{
  #         kpiResultRightVector <-
  #           c(kpiResultRightVector, content[[1]][3, "value"])
  #       }
  #     }
  #     yearCnt <- yearCnt + 1
  #   }
  #   if (sum(kpiResultRightVector) == 0) {
  #     # print no data message
  #     output$Barplot_Right = renderPlot({
  #       par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
  #       plot(
  #         1,
  #         1,
  #         col.main = "lightgray",
  #         col.lab = "lightgray",
  #         col.axis = "lightgray",
  #         fg = "lightgray"
  #       )
  #       text(1, 1, "No data available:'( blame the government", col = "red")
  #     })
  #   }
  #   else{
  #     # plot the datarina (????)
  #     names(kpiResultRightVector) <- c(yearMin:yearMax)
  #     output$Barplot_Right = renderPlot({
  #       par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
  #       barplot(
  #         kpiResultRightVector,
  #         main = "Holy Fudge!",
  #         col = c("springgreen2", "mediumaquamarine"),
  #         col.main = "lightgray",
  #         col.lab = "lightgray",
  #         col.axis = "lightgray",
  #         fg = "lightgray",
  #         border = "lightgray",
  #         las = 3
  #       ) +
  #         abline(
  #           h = mean(kpiResultRightVector[kpiResultRightVector != 0]),
  #           lty = 3,
  #           col = "lightgray"
  #         )
  #     })
  #   }
  # })
  
  observeEvent(input$PlotButtonRight, {
    # Right Panel
    municipalityDropDownListRightHolder = as.character(input$municipalityDropDownListRight)
    kpiDropDownListRightHolder = as.character(input$kpiDropDownListRight)
    
    municipalityDropDownListRightId = as.matrix(municipalitiesDataFrame["values.id"])[match(
      as.character(input$municipalityDropDownListRight),
      as.matrix(municipalitiesDataFrame["values.title"])
    )]
    
    yearMin <- as.numeric(input$yearDropDownListRight)[1]
    yearMax <- as.numeric(input$yearDropDownListRight)[2]
    yearCnt <- as.numeric(input$yearDropDownListRight)[1]
    
    kpiResultRightVector <- c()
    while (yearCnt <= yearMax) {
      kpiResultRight <-
        fetchByKpi(
          as.character(input$kpiDropDownListRight),
          municipalityDropDownListRightId,
          yearCnt
        )
      if (nrow(kpiResultRight) == 0) {
        kpiResultRightVector <- c(kpiResultRightVector, 0)
      }
      else{
        content = kpiResultRight[1, "values.values"]
        # Some times despite having some data in the row, the value we are looking for is not found and a NA is returned
        if (is.na(content[[1]][3, "value"])) {
          kpiResultRightVector <-
            c(kpiResultRightVector, 0)
        }
        else{
          kpiResultRightVector <-
            c(kpiResultRightVector, content[[1]][3, "value"])
        }
      }
      yearCnt <- yearCnt + 1
    }
    if (sum(kpiResultRightVector) == 0) {
      # print no data message
      output$Barplot_Right = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
        plot(
          1,
          1,
          col.main = "lightgray",
          col.lab = "lightgray",
          col.axis = "lightgray",
          fg = "lightgray"
        )
        text(1, 1, "No data available:'( blame the government", col = "red")
      })
    }
    else{
      # plot the datarina
      names(kpiResultRightVector) <- c(yearMin:yearMax)
      output$Barplot_Right = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue = 255))
        par(mar = c(5,4,4.2,2), xpd = TRUE)
        barplot(
          kpiResultRightVector,
          main = paste(as.character(municipalityDropDownListRightHolder), as.character(kpiDropDownListRightHolder), "KPI historical performance."),
          xlab = "Year",
          ylab = "KPI performance",
          cex.lab = 1.2,
          col = transparent(c(
            "springgreen2", "mediumaquamarine"
          ), trans.val = 0.8),
          col.main = "lightgray",
          col.lab = "lightgray",
          col.axis = "lightgray",
          fg = "lightgray",
          border = "lightgray",
          las = 3
        )
        abline(
          h = mean(kpiResultRightVector[kpiResultRightVector != 0]),
          lty = 2,
          lwd = 2,
          col = 'mediumpurple3'
        )
        abline(
          glm(kpiResultRightVector[kpiResultRightVector != 0] ~ c(1:length(
            kpiResultRightVector[kpiResultRightVector != 0]
          ))),
          lty = 2,
          lwd = 2,
          col = 'yellow3'
        )
        # Add legend
        legend(
          "bottomright",
          #inset=c(0.05, -0.2),
          legend = c("Median", "Linear trend"),
          col = c('mediumpurple3', 'yellow3'),
          bg = transparent(rgb(31.5, 38.6, 44.3, maxColorValue = 255), trans.val = 0.15),
          box.col = "lightgray",
          text.col = "lightgray",
          lty = 2,
          lwd = 2
        )
      })
    }
  })
}

ui = shinyUI(fluidPage( theme = shinytheme("slate"), fluidRow(column(
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

shinyApp(ui = ui, server = server)
