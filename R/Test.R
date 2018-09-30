library(shiny)
library(ggplot2)
library(httr)
library(jsonlite)
source(
  'C:/Users/ruben/Desktop/Classes/732A94 Advanced Programming in R/Lab 05/advanced-r-programming-5/R/webServices.R'
)
ui <- fluidPage(
  h1("kola database", align = "center"),
  hr(),
  br(),
  p(em("Retrive data")),
  actionButton(inputId = "button01", label = "Go"),
  br(),
  splitLayout(#object 1,
    verticalLayout(
      wellPanel(
        "Text place holder",
        br(),
        verbatimTextOutput("munId"),
        uiOutput("DropList")
      ),
      plotOutput("Plot01")
    ),
    wellPanel(p(em(
      "Place Holder"
    )))
    #object 2)
    
    # ,
    # splitLayout(
    #   wellPanel(
    #     h4("The municipality chosen is "),
    #     verbatimTextOutput("inoutTest")
    #   ),
    #   wellPanel(h4("The municipality ID is"),
    #             verbatimTextOutput("inoutTest2"))
    # ),
    # # wellPanel(p("Result of ", code("A * B")),
    # #           verbatimTextOutput("inoutTest3")),
    # wellPanel(plotOutput("inoutTest5")),
    # wellPanel(p("Vector testing"),
    #           tableOutput("inoutTest4"))
    #*Output()functions
  )
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
      output$inoutTest <- renderPrint("LOADING")
      output$inoutTest2 <- renderPrint("LOADING")
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
      output$inoutTest <- renderPrint("LOADING")
      output$inoutTest2 <- renderPrint("LOADING")
      
      municipalityName <<- paste(input$DropMenu)
      municipalityId <<- match(municipalityName, municipalityList)
      
      
      #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      municipalityValuesTemp <<-
        fetchByMunicipality(municipalityListId[municipalityId], 2016)
      municipalityValues <<- municipalityValuesTemp["values.values"]
      
      cnt <- 1
      valVector <- c()
      temp0101 <- list()
      while (!is.null(temp0101)) {
        valAns <- (municipalityValues$values.values)[cnt]
        temp0101 <- valAns[[1]]
        valVector <- c(valVector, unlist(temp0101["value"]))
        cnt <- cnt + 1
      }
      #print(valVector)
      #print(class(valVector))
      # temp01 <- (municipalityValues$values.values)[4]
      # temp0101 <- temp01[[1]]
      # print(temp0101)
      # print(temp0101["value"])
      #output$inoutTest4 <- renderTable(as.list(municipalityValues))
      
      
      
      output$inoutTest <- renderPrint(municipalityName)
      output$inoutTest2 <-
        renderPrint(municipalityListId[municipalityId])
      output$munId <- renderPrint(municipalityListId[municipalityId])
      output$Plot01 <- renderPlot({
        plot(valVector, type = "h")
      })
      
    })
  }
  
  shinyApp(ui = ui, server = server)
  