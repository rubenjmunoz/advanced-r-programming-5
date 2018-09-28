# Call the recover function when an error occurs
options(error = recover)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application

library(httr)
library(jsonlite)

base = "http://api.kolada.se/"
endpoint = "v1/ou/data/peryear/N15030/2011"


webCall = paste(base, endpoint)

result = GET(webCall)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mpgData,
            outline = input$outliers)
  })
})