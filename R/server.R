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
  output$yearDropDownListRight = renderUI({
    selectInput(inputId = "yearDropDownListRight",
                choices = yearsAsVector,
                label = "Select Year:")
  })
  
  observeEvent(input$PlotButtonLeft, {
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
        fetchByKpi(as.character(input$kpiDropDownListLeft),
                   municipalityDropDownListLeftId,
                   yearCnt)
      if (nrow(kpiResultLeft) == 0) {
        kpiResultLeftVector <- c(kpiResultLeftVector, 0)
      }
      else{
        content = kpiResultLeft[1, "values.values"]
        kpiResultLeftVector <-
          c(kpiResultLeftVector, content[[1]][3, "value"])
      }
      yearCnt <- yearCnt + 1
    }
    names(kpiResultLeftVector) <- c(yearMin:yearMax)
    output$Barplot_Left = renderPlot({
      barplot(kpiResultLeftVector, main = "Holy Fudge!") + liu_theme()
    })
  })
  
})

#' Liu Theme
#'
#' @param base_size The base size of the font.
#' @param base_family The base family of the font.
#'
#' @return The Liu Theme. Add this to our plot.
#' @export
#'
liu_theme = function(base_size = 11, base_family = "") {
  {
    half_line <- base_size/2
    theme(line = element_line(colour = "black", size = 0.5, linetype = 1,
                              lineend = "butt"), rect = element_rect(fill = "#232323",
                                                                     colour = "black", size = 0.5, linetype = 1), text = element_text(family = base_family,
                                                                                                                                      face = "plain", colour = "#54d8e0", size = base_size, lineheight = 0.9,
                                                                                                                                      hjust = 0.5, vjust = 0.5, angle = 0, margin = margin(), debug = FALSE),
          axis.line = element_line(),
          axis.line.x = element_blank(),
          axis.line.y = element_blank(),
          axis.text = element_text(size = rel(0.8), colour = "#54d8e0"),
          axis.text.x = element_text(margin = margin(t = 0.8 * half_line/2), vjust = 1), axis.text.y = element_text(margin = margin(r = 0.8 * half_line/2), hjust = 1),
          axis.ticks = element_line(colour = "#ffffff"),
          axis.ticks.length = unit(half_line/2, "pt"),
          axis.title.x = element_text(margin = margin(t = 0.8 * half_line, b = 0.8 * half_line/2)),
          axis.title.y = element_text(angle = 90, margin = margin(r = 0.8 * half_line, l = 0.8 * half_line/2)),
          legend.background = element_rect(colour = "#ffffff"), legend.key = element_rect(fill = "#ffffff", colour = "white"), legend.key.size = unit(1.2, "lines"),
          legend.key.height = NULL,
          legend.key.width = NULL,
          legend.text = element_text(size = rel(0.8)),
          legend.text.align = NULL,
          legend.title = element_text(hjust = 0),
          legend.title.align = NULL,
          legend.position = "right",
          legend.direction = NULL,
          legend.justification = "center",
          legend.box = NULL,
          panel.background = element_rect(fill = "#3e4d4f", colour = NA),
          panel.border = element_blank(),
          panel.grid.major = element_line(colour = "#dddddd"),
          panel.grid.minor = element_line(colour = "#cccccc", size = 0.25),
          panel.margin.y = NULL, panel.ontop = FALSE,
          strip.background = element_rect(fill = "#ffffff", colour = NA),
          strip.text = element_text(colour = "#ffffff", size = rel(0.8)),
          strip.text.x = element_text(margin = margin(t = half_line,b = half_line)),
          strip.text.y = element_text(angle = -90, margin = margin(l = half_line, r = half_line)),
          strip.switch.pad.grid = unit(0.1, "cm"), strip.switch.pad.wrap = unit(0.1, "cm"),
          plot.background = element_rect(colour = "white"),
          plot.title = element_text(size = rel(1.2),
                                    margin = margin(b = half_line * 1.2)),
          plot.margin = margin(half_line, half_line, half_line, half_line),complete = TRUE)
  }
}