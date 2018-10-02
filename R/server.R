# Call the recover function when an error occurs
options(error = recover)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application

# mpgData = mtcars
# mpgData$am = factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
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
  
  # Year Dropdown Left
  # output$yearDropDownListLeft = renderUI({
  #   selectInput(inputId = "yearDropDownListLeft",
  #               choices = yearsAsVector,
  #               label = "Select Year:")
  # })
  # output$yearDropDownListLeft = renderPrint(input$)
  
  # Year Dropdown Right
  # output$yearDropDownListRight = renderUI({
  #   selectInput(inputId = "yearDropDownListRight",
  #               choices = yearsAsVector,
  #               label = "Select Year:")
  # })
  
  observeEvent(input$PlotButtonLeft, {
    # Left Panel
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
          as.character(input$kpiDropDownListLeft),
          municipalityDropDownListLeftId,
          yearCnt
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
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue=255))
        plot(1, 1, col = "white",
             col.main="lightgray",
             col.lab ="lightgray",
             col.axis="lightgray",
             fg = "lightgray")
        text(1, 1, "No data available:'( blame the government", col = "red")
      })
    }
    else{
      # plot the datarina
      names(kpiResultLeftVector) <- c(yearMin:yearMax)
      output$Barplot_Left = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue=255))
        barplot(
          kpiResultLeftVector,
          main = "Holy Fudge!",
          col = c("springgreen2", "mediumaquamarine"),
          col.main="lightgray",
          col.lab ="lightgray",
          col.axis="lightgray",
          fg = "lightgray",
          border = "lightgray",
          las = 3
        )
      })
    }
  })
  
  
  observeEvent(input$PlotButtonRight, {
    # Right panel
    municipalityDropDownListRightId = as.matrix(municipalitiesDataFrame["values.id"])[match(
      as.character(input$municipalityDropDownListRight),
      as.matrix(municipalitiesDataFrame["values.title"])
    )]
    
    yearMin <- as.numeric(input$yearDropDownListRight)[1]
    yearMax <- as.numeric(input$yearDropDownListRight)[2]
    yearCnt <- as.numeric(input$yearDropDownListRight)[1]
    
    kpiResultRightVector <- c()
    # while (yearCnt <= yearMax) {
    #   kpiResultRight <-
    #     fetchByKpi(
    #       as.character(input$kpiDropDownListRight),
    #       municipalityDropDownListRightId,
    #       yearCnt
    #     )
    #   if (nrow(kpiResultRight) == 0) {
    #     kpiResultRightVector <- c(kpiResultRightVector, 0)
    #   }
    #   else{
    #     content = kpiResultRight[1, "values.values"]
    #     kpiResultRightVector <-
    #       c(kpiResultRightVector, content[[1]][3, "value"])
    #   }
    #   yearCnt <- yearCnt + 1
    # }
    # names(kpiResultRightVector) <- c(yearMin:yearMax)
    # output$Barplot_Right = renderPlot({
    #   barplot(
    #     kpiResultRightVector,
    #     main = "Holy Fudge!",
    #     col = c("springgreen2", "mediumaquamarine"),
    #     las = 3
    #   )
    # })
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
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue=255))
        plot(1, 1, col = "gray", 
             col.main="lightgray",
             col.lab ="lightgray",
             col.axis="lightgray",
             fg = "lightgray")
        text(1, 1, "No data available:'( blame the government", col = "red")
      })
    }
    else{
      # plot the datarina (????)
      names(kpiResultRightVector) <- c(yearMin:yearMax)
      output$Barplot_Right = renderPlot({
        par(bg = rgb(31.5, 38.6, 44.3, maxColorValue=255))
        barplot(
          kpiResultRightVector,
          main = "Holy Fudge!",
          col = c("springgreen2", "mediumaquamarine"),
          col.main="lightgray",
          col.lab ="lightgray",
          col.axis="lightgray",
          fg = "lightgray",
          border = "lightgray",
          las = 3
        )
      # output$Barplot_Right = renderPlot({
      #   # Create data
      #   data = data.frame(Year = as.character(c(yearMin:yearMax)) ,  Value =
      #                       kpiResultRightVector)
      #   # Barplot
      #   ggplot(data, aes(x = Year, y = Value, fill = rgb(.5,.5,.5), color = "red")) +
      #     geom_bar(stat = "identity")
      #   # +
      #   #   theme_dark()
       })
    }
  })
})