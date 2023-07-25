
# Load packages ----
source("helpers.R")
source("tooltip_css.R")

# Load data staafdiagram (op stadsdeelniveau)---
load("ms_shiny_map.RData")

# User interface ----
ui <- fluidPage(
  
  use_font("roboto", "www/css/roboto.css"),
  
  titlePanel("Transactiedata in Amsterdam 2019 - 2023"),
  
  br(),  # line breaks
  
  sidebarLayout(
    
    sidebarPanel(
      
      helpText("Maak een tijdreeks per branche aan de hand van bestedingen of transacties"),
      
      selectInput(
        inputId  = "waarde",
        label    = "Kies bestedingen of transacties",
        choices  = c("Bestedingen"         = "normalised_euros",
                     "Transacties"         = "normalised_transactions",
                     "Gewogen bestedingen" = "corrected_euros",
                     "Gewogen transacties" = "corrected_transactions"),
        selected = "Bestedingen"),
      
      selectInput(
        inputId  = "tijd",
        label    = "Kies tijdseenheid",
        choices  = c("jaar"     = "jaar",
                     "kwartaal" = "jaar_kwartaal",
                     "maand"    =  "jaar_maand",
                     "week"     = "jaar_week"),
        selected =  "jaar_maand"),
      

      checkboxGroupInput(
        inputId = "branche", 
        label = "Kies een branche",
        choices = c ("Detailhandel dagelijks", 
                     "Detailhandel niet-dagelijks: mode",
                     "Detailhandel niet-dagelijks: Overig",
                     "Restaurant-cafés"),
        selected =  "Detailhandel dagelijks"),
      
      checkboxGroupInput(
        inputId = "sd", 
        label = "Kies een gebied",
        choices = c ("Centrum", 
                     "West",
                     "Nieuw-West",
                     "Zuid",
                     "Oost",
                     "Noord",
                     "Zuidoost",
                     "Weesp"),
        selected =  "Centrum"),
      
      dateRangeInput(
        inputId = "datum",
        label = "begin- en einddatum",
        start = "2018-07-01",
        end = Sys.time()),
      
      checkboxInput(inputId = "show_data",
                    label = "wil je de tabel zien?", 
                    value = FALSE)

    ),
    

    
    mainPanel(
      tabsetPanel(
          tabPanel("staafdiagram", girafeOutput("staafdiagram")), 
          tabPanel("tabel", dataTableOutput("tabel"))
        )

    )
  )
)

# Server logic ----
server <- function(input, output, session) {
  
  data_input1 <- reactive({my_plot_staaf(
      ms_long, 
      tijd = input$tijd,
      sd   = input$sd,
      waarde  = input$waarde,
      branche = input$branche, 
      xmin = input$datum[1], 
      xmax = input$datum[2])
  })
  
  output$staafdiagram <- renderGirafe({ 
    
    girafe(ggobj = data_input1()) 
  })
  
  data_input2<- reactive({my_plot_tabel(
    ms_long, 
    tijd = input$tijd,
    sd   = input$sd,
    waarde  = input$waarde,
    branche = input$branche,
    xmin = input$datum[1], 
    xmax = input$datum[2])
  })
  
  output$tabel <- renderDataTable({
    if(input$show_data){
        datatable(data = data_input2(), 
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
    })
  
  }







# Run app ----
shinyApp(ui, server)



