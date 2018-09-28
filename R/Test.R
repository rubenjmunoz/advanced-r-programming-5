library(shiny)
library(ggplot2)
library(httr)
library(jsonlite)


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
    wellPanel(h4("A Value"),
              verbatimTextOutput("inoutTest")),
    wellPanel(h4("B Value"),
              verbatimTextOutput("inoutTest2"))
  ),
  wellPanel(p("Result of ", code("A * B")),
            verbatimTextOutput("inoutTest3")),
  wellPanel(p("Vector testing"),
            tableOutput("inoutTest4")),
  wellPanel(plotOutput("inoutTest5"))
  #*Output()functions
)


server <- function(input, output, session) {
  SlideValue <- c()
  DropMenuList <- list()
  
  vData <- reactive({
    SlideValue <<- c(SlideValue, input$A * input$B)
  })
  
  observeEvent(input$A, {
    vData()
  })
  
  observeEvent(input$button01, {
    qry_Headers <<-
      fromJSON("http://api.kolada.se/v2/municipality?", flatten = TRUE)
    testerino <<- as.data.frame(qry_Headers[2])
    
    municipalityList <<- as.matrix(testerino["values.title"])
    
    output$DropList <- renderUI({
      selectInput(inputId = "DropMenu",
                  choices = municipalityList,
                  label = "")
    })
  })
  
  
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  
  observeEvent(input$DropMenu, {
    municipalityName <<- paste(input$DropMenu)
    municipalityId <<- match(municipalityName, municipalityList)
    # print(municipalityName)
    # print(class(municipalityName))
    # #print(municipalityName)
    # print(class(municipalityList))
    # print(municipalityId)
    # print(class(municipalityId))
    # print("----")
    
    output$munId <-renderPrint(municipalityId)
    output$inoutTest4 <- renderTable(testerino)
  })
  
  
  
  
    output$inoutTest <- renderPrint(input$A)
    output$inoutTest2 <- renderPrint(input$B)
    output$inoutTest3 <- renderPrint(input$A * input$B)
    
    output$inoutTest5 <- renderPlot({
      plot(vData(), type = "o")
    })
}

shinyApp(ui = ui, server = server)
