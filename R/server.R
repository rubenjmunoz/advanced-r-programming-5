# Call the recover function when an error occurs
options(error = recover)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application

mpgData = mtcars
mpgData$am = factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  municipalitiesDataFrame = fetchMunicipalities()
  kpisDataFrame = fetchKpis()
  yearsAsVector = c(1980:2018)
  
  # Municipality Dropdown Left
  output$municipalityDropDownListLeft = renderUI({
    selectInput(inputId = "municipalityDropDownListLeft",
                choices = as.matrix(municipalitiesDataFrame["values.title"]),
                label = "Select Municipality:")
  })
  
  # Municipality Dropdown Right
  output$municipalityDropDownListRight = renderUI({
    selectInput(inputId = "municipalityDropDownListRight",
                choices = as.matrix(municipalitiesDataFrame["values.title"]),
                label = "Select Municipality:")
  })
  
  # Kpi Dropdown Left
  output$kpiDropDownListLeft = renderUI({
    selectInput(inputId = "kpiDropDownListLeft",
                choices = as.matrix(kpisDataFrame["member_id"]),
                label = "Select KPI:")
  })
  
  # Kpi Dropdown Right
  output$kpiDropDownListRight = renderUI({
    selectInput(inputId = "kpiDropDownListRight",
                choices = as.matrix(kpisDataFrame["member_id"]),
                label = "Select KPI:")
  })
  
  # Year Dropdown Left
  output$yearDropDownListLeft = renderUI({
    selectInput(inputId = "yearDropDownListLeft",
                choices = yearsAsVector,
                label = "Select Year:")
  })
  
  # Year Dropdown Right
  output$yearDropDownListRight = renderUI({
    selectInput(inputId = "yearDropDownListRight",
                choices = yearsAsVector,
                label = "Select Year:")
  })
  
  observeEvent(input$PlotButtonLeft, {
    #print(list(input$kpiDropDownListLeft))
    #print(municipalitiesDataFrame[which(input$municipalityDropDownListLeft == municipalitiesDataFrame$values_title), "values.id"])
    #print(match(input$municipalityDropDownListLeft, municipalitiesDataFrame))
    #municipalityName = paste(input$municipalityDropDownListLeft)
    
    temporinoList = as.matrix(municipalitiesDataFrame["values.title"])
    temporinoName = as.matrix(municipalitiesDataFrame["values.id"])
    temporinoDropDownName = paste(input$municipalityDropDownListLeft)
    municipalityId = match(temporinoDropDownName, temporinoList)
    temporinoId = temporinoName[municipalityId]

    
    #print(as.numeric(input$yearDropDownListLeft))
    fakeList = list()
    #kpiResultLeft = fetchByKpi(list(input$kpiDropDownListLeft), temporinoId, paste(input$yearDropDownListLeft))
    print(input$yearDropDownListLeft)
    print(as.numeric(input$yearDropDownListLeft))
    pasteTesterino = paste(input$yearDropDownListLeft)
    kpiResultLeft = fetchByKpi(list("N00914,U00405"), temporinoId, as.numeric(input$yearDropDownListLeft))
    #print(head(kpiResultLeft))
    if (nrow(kpiResultLeft) == 0) {
      showModal(modalDialog(
        title = "No data received",
        paste0("The webcall was successfull but the answer does not contain any data."),
        easyClose = TRUE,
        footer = NULL
      ))
    }
    else {
      content = kpiResultLeft[1, "values.values"]
      print(content)
      value = content[[1]][3, "value"]
      print(value)
      #print(value[3])
      #actualValue = values[3]
      
      output$Barplot_Left = renderPlot({
        plot(value, type = "h")
      }) 
    }
  })
  
})