# Load packages ----


source("helpers.R")
source("tooltip_css.R")

# Load data ---
load("ms_shiny_staaf.RData")



# User interface ----
ui <- fluidPage(
  
  use_font("roboto", "www/css/roboto.css"),
  
  titlePanel("Transactiedata in Amsterdam 2019 - 2023"),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Maak een tijdreeks per branche aan de hand van bestedingen of transacties"),
      
      selectInput(
        inputId  = "waarde_i",
        label    = "Kies bestedingen of transacties",
        choices  = c("Bestedingen"= "normalised_euros",
                    "Transacties"= "normalised_transactions"),
        selected = "Bestedingen"),
      
      selectInput(
        inputId  = "tijd",
        label    = "Kies tijdseenheid",
        choices  = c("jaar"= "jaar",
                    "kwartaal" = "jaar_kwartaal",
                    "maand" =  "jaar_maand",
                    "week" = "jaar_week"),
        selected =  "jaar_maand"),
      

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
        start = "2018-07-01",
        end = Sys.time())
      
    ),
    

    
    mainPanel(
      
      # Output: Histogram ----
      girafeOutput(outputId = "staafdiagram")
      
      
    )
  )
)

# Server logic ----
server <- function(input, output) {
  
  output$staafdiagram <- renderGirafe({  
    
 y<-    my_plot_staaf(
        ms_long, 
        tijd = input$tijd,
        waarde  = input$waarde_i,
        branche = input$branche, 
        xmin = input$datum[1], 
        xmax = input$datum[2])
 
 girafe(ggobj = y)
 
      })
  }






# Run app ----
shinyApp(ui, server)



