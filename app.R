# Load packages ----
library(shiny)
library(dplyr)
library(ggplot2)


load("ms_shiny.RData")



theme_os <- function(orientation="vertical", legend_position = "bottom"){
  
  theme <- ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text = ggplot2::element_text( size = 13),
      plot.caption = ggplot2::element_text( size = 14),
      axis.title = ggplot2::element_text( hjust = 1, size = 13),
      plot.subtitle = ggplot2::element_text( size = 15),
      legend.text = ggplot2::element_text( size = 12),
      plot.title = ggplot2::element_text( lineheight = 1.2, size = 15),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      legend.title=element_blank(),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_blank(),
      legend.position=legend_position,
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black",  face = "bold", size = 15)
    ) 
  
  return(theme)
}

# User interface ----
ui <- fluidPage(
  titlePanel("Transactiedata in Amsterdam 2019 - 2023"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Maak een tijdreeks per branche aan de hand van bestedingen of transacties"),
      
      selectInput(
        inputId = "waarde_i",
        label = "Kies bestedingen of transacties",
        choices = c("Bestedingen"= "normalised_euros",
                    "Transacties"= "normalised_transactions"),
        selected = "Bestedingen"),
      
      checkboxGroupInput(
        inputId = "stadsdeel",
        label = "Kies een gebied",
        choices = c("Centrum",
                    "NW, Noord, Zuidoost, Weesp",
                    "West, Zuid, Oost"),
        selected = "Centrum"),
      
      checkboxGroupInput(
        inputId = "branche", 
        label = "Kies een branche",
        choices = c ("Detailhandel dagelijks", 
                     "Detailhandel niet-dagelijks: mode",
                     "Detailhandel niet-dagelijks: Overig",
                     "Restaurant-cafés"),
        selected =  "Detailhandel dagelijks"),
      
      dateRangeInput(
        inputId = "datum",
        label = "begin- en einddatum",
        start = "2019-01-01",
        end = "2023-04-24")
      
    ),
    

    
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "kaart")
    )
  )
)

# Server logic ----
server <- function(input, output) {
    
  output$kaart <- renderPlot({
    
     ms_long |>
      my_plot (sd =input$stadsdeel,
               waarde  = input$waarde_i,
               branche = input$branche, 
               xmin = input$datum[1], 
               xmax = input$datum[2])+
      theme_os()
    
  })
}





# Run app ----
shinyApp(ui, server)

