

### basis script transacties in shiny ---


library(openxlsx)
library(tidyverse)
library(ggplot2)
library(lubridate)

# Load data ----

ms<- read.xlsx("xlsx/Mastercard_sector7_maand_sd.xlsx")


# figuur 

ms$date<-glue::glue("{ms$year}-{ms$month}")



ms$datum   <-ym(ms$date)



ms <- ms |>
  mutate(
    
    herkomst=case_when(
      zeven_landen_indeling == 'Continent: Europa Nederland' ~ 'Nederland',
      TRUE ~ 'Buitenland'),
    
    locatie=case_when(
      gebied_code=='A'  ~'Centrum',
      gebied_code %in% c('E', 'K', 'M')  ~ 'West, Zuid, Oost',
      TRUE ~ 'NW, Noord, Zuidoost, Weesp')
  )


ms_long<- ms |>
  pivot_longer(cols= c(normalised_euros:corrected_transactions)) |>
  filter(sector %in% c("Detailhandel dagelijks"  , 
                       "Detailhandel niet-dagelijks: mode" ,  
                       "Detailhandel niet-dagelijks: Overig", 
                       "Restaurant-cafés" ),
         name %in% c('normalised_euros','normalised_transactions'))
    



# figuur 


#source("http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R")



my_plot <- function(x, sd,  waarde, branche, xmin, xmax){
  
  x|>
    
    filter(sector %in% branche,
           locatie %in% sd,
           name == waarde) |>
    
    group_by(datum, sector, locatie, name, herkomst) |>
    
    summarise(value=sum(value)) |>
    
    ggplot(aes(x= datum ,y= value, fill = sector)) +
    
    geom_col()+
    
    labs(title=NULL, 
         x=NULL,
         y = NULL) +
    
    theme_os()+ 
    
    scale_fill_manual(name= NULL, 
                      values = wild_pal) +
    guides(fill = guide_legend(nrow = 2, reverse = T))+
    
    xlim(xmin, xmax) +
    
    facet_wrap( ~ herkomst)
  
}


# #### test 
# ms_long |>
#   my_plot (sd = c("Centrum", 'NW, Noord, Zuidoost, Weesp'),
#            waarde  = "normalised_euros",
#            branche = c("Detailhandel niet-dagelijks: mode", "Detailhandel niet-dagelijks: Overig" ),
#            xmin= ms_long$datum["2019-01-01"],
#            xmax= ms_long$datum["2023-01-01"])


save(ms, ms_long, theme_os, my_plot, file = "ms_shiny.RData")
