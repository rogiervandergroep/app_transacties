# Load packages ----
library(shiny)
library(tidyverse)
source("http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R")

load("ms_shiny.RData")






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
               xmax = input$datum[2])
    
  })
}





# Run app ----
shinyApp(ui, server)

