# Call the recover function when an error occurs
options(error = recover)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  municipalitiesDataFrame = fetchMunicipalities()
  
  # Municipality Dropdown
  output$municipalityDropDownList <- renderUI({
    selectInput(inputId = "municipalityDropDownList",
                choices = as.matrix(municipalitiesDataFrame["values.title"]),
                label = "This is the label")
  })
  
  
  
})