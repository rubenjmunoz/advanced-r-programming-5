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
  #testterino <- data.frame()
  vData <- reactive({
    SlideValue <<- c(SlideValue, input$A * input$B)
  })
  
  observeEvent(input$A, {
    vData()
  })
  
  observeEvent(input$button01, {
    qry_Headers <<-
      fromJSON("http://api.kolada.se/v2/municipality?", flatten = TRUE)
    testerino <- as.data.frame(qry_Headers[2])
    
    municipalityList <- as.data.frame(testerino["values.title"])
    #print(class(municipalityList))
    #print(municipalityList)
    municipalityName <- input$DropMenu
    print(municipalityName)
    municipalityId <<- municipalityList[municipalityList[(input$DropMenu),2]==(input$DropMenu),1]
    output$inoutTest4 <- renderTable(qry_Headers)
    output$DropList <- renderUI({
      selectInput(inputId = "DropMenu",
                  choices = municipalityList,
                  label = "")
    })
    output$munId <- renderPrint(municipalityId)
  })
  observeEvent(input$DropMenu, {
    print(input$DropMenu)
  })
  
  refreshedDropList <- eventReactive(input$button01, {
    
  })
  
  output$inoutTest <- renderPrint(input$A)
  output$inoutTest2 <- renderPrint(input$B)
  output$inoutTest3 <- renderPrint(input$A * input$B)
  
  output$inoutTest5 <- renderPlot({
    plot(vData(), type = "o")
  })
}

shinyApp(ui = ui, server = server)
