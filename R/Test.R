library(shiny)
library(ggplot2)
library(httr)
library(jsonlite)
source(
  'C:/Users/ruben/Desktop/Classes/732A94 Advanced Programming in R/Lab 05/advanced-r-programming-5/R/webServices.R'
)
ui <- fluidPage(
  h1("This is the main text SUPER TITLE", align = "center"),
  hr(),
  br(),
  sidebarLayout(
    sidebarPanel(tabsetPanel(
      tabPanel(
        "Useless",
        br(),
        p(em("Retrive data")),
        br(),
        actionButton(inputId = "button01", label = "Click me"),
        br(),
        verbatimTextOutput("munId"),
        uiOutput("DropList"),
        align = "center"
      ),
      tabPanel("Button Check",
               br(),
               actionButton("button02", "update text"))
    )),
    mainPanel(
      sliderInput(
        inputId = "A",
        label =  "Choose A value",
        min = 0,
        max = 100,
        value = 0,
        step = 1,
        width = '100%',
        animate = TRUE
      ),
      sliderInput(
        inputId = "B",
        label =  "Choose B value",
        min = 0,
        max = 100,
        value = 0,
        step = 2,
        animate = animationOptions(loop = TRUE),
        width = '100%'
      )
    )
  ),
  splitLayout(
    wellPanel(
      h4("The municipality chosen is "),
      verbatimTextOutput("inoutTest")
    ),
    wellPanel(h4("The municipality ID is"),
              verbatimTextOutput("inoutTest2"))
  ),
  # wellPanel(p("Result of ", code("A * B")),
  #           verbatimTextOutput("inoutTest3")),
  wellPanel(plotOutput("inoutTest5")),
  wellPanel(p("Vector testing"),
            tableOutput("inoutTest4"))
  #*Output()functions
)


server <- function(input, output, session) {
  SlideValue <- c()
  
  vData <- reactive({
    SlideValue <<- c(SlideValue, input$A * input$B)
  })
  
  observeEvent(input$A, {
    vData()
  })
  
  observeEvent(input$button01, {
    testerino <<- fetchMunicipalities()
    
    municipalityList <<- as.matrix(testerino["values.title"])
    municipalityListId <<- as.matrix(testerino["values.id"])
    output$DropList <- renderUI({
      selectInput(inputId = "DropMenu",
                  choices = municipalityList,
                  label = "")
    })
  })
    observeEvent(input$DropMenu, {
    municipalityName <<- paste(input$DropMenu)
    municipalityId <<- match(municipalityName, municipalityList)
    
    
    #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    municipalityValuesTemp <<-
      fetchByMunicipality(municipalityListId[municipalityId], 2015)
    municipalityValues <<- municipalityValuesTemp["values.values"]
    temp01 <- (municipalityValues$values.values)[4]
    print(temp01)
    print(temp01[1]$value)
    #output$inoutTest4 <- renderTable(as.list(municipalityValues))
    
    
    
    output$inoutTest <- renderPrint(municipalityName)
    output$inoutTest2 <-
      renderPrint(municipalityListId[municipalityId])
    output$munId <- renderPrint(municipalityListId[municipalityId])
    # output$inoutTest5 <- renderPlot({
    #   plot(municipalityValues, type = "o")
    # })
   
  })
}

shinyApp(ui = ui, server = server)
