


library(shiny)
library(openxlsx)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(ggiraph)
library(glue)
library(ISOweek)
library(sf)
library(ggiraph)
library(gtools)
library(DT)

#source("http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R")

my_plot_tabel <- 
  function(x, branche, waarde, tijd, sd, xmin, xmax){
    
    x|>
      filter(sector %in% branche,
             name == waarde,
             tijd_type == tijd,
             sd_naam %in% sd,
             datum %in% c(xmin:xmax)) |>
      
      group_by(sector,  datum,  herkomst) |>
      
      summarise(value=sum(value, na.rm = T))
  }





theme_shiny_figuur <- function(){
  
  ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(family = font, size = 13),
      plot.caption = ggplot2::element_text(family = font, size = 14),
      axis.title = ggplot2::element_text(family = font, hjust = 1, size = 13),
      plot.subtitle = ggplot2::element_text(family = font, size = 15),
      legend.text = ggplot2::element_text(family = font, size = 12),
      plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 15),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      legend.title=element_blank(),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_blank(),
      legend.position='bottom',
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black", family = font, face = "bold", size = 15)
  ) 
}

my_plot_staaf <- 
  function(x, branche, waarde, tijd, sd, xmin, xmax){
  
  
  wild_pal <- c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000")
  
  x|>
    filter(sector %in% branche,
           name == waarde,
           tijd_type == tijd,
           sd_naam %in% sd) |>
    
    group_by(sector,  datum,   herkomst) |>
    
    summarise(value=sum(value, na.rm = T)) |>
    
    mutate(tooltip = glue:: glue("{datum} \n
                                  {sector} \n
                                  {format(round(value, 2), 
                                  
                                 big.mark = '.', 
                                 decimal.mark= ',' , 
                                 scientific = F)}"))  |>
    
    ggplot(aes(x= datum ,y= value, fill = sector, tooltip = tooltip, data_id = value )) +
    theme_shiny_figuur() +
    geom_col_interactive()+
    labs(title=NULL, x=NULL,y = NULL) +
    scale_fill_manual(name= NULL, values = wild_pal) +
    guides(fill = guide_legend(nrow = 2, reverse = T))+
    xlim(xmin, xmax) +
    facet_wrap( ~ fct_rev(herkomst))

}

