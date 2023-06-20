

### basis ---
source("helpers.R")  #libraries
source("http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R") #functies
source("tooltip_css.R")


# Load data ---
ms     <- read.xlsx("../transactiedata/levering 6 tm 1 juni 2023/xlsx/Mastercard_sector7_week_sd.xlsx")


ms$week<- str_pad(ms$week, side = "left", width = 2, pad = 0)
ms$date <- glue ("{ms$year}-W{ms$week}-5")

ms$jaar_week     <- date(ISOweek2date(ms$date))
ms$jaar_maand    <- floor_date(ms$jaar_week, unit= 'month')
ms$jaar_kwartaal <- quarter(ms$jaar_week, type="date_first")
ms$jaar          <- floor_date(ms$jaar_week, unit = 'year')


ms <- ms |>
  mutate(
    
    herkomst=case_when(
      zeven_landen_indeling == 'Continent: Europa Nederland' ~ 'Nederland',
      TRUE ~ 'Buitenland'),
    
    locatie=case_when(
      gebied_code=='A'  ~'Centrum',
      gebied_code %in% c('E', 'K', 'M')  ~ 'West, Zuid, Oost',
      TRUE ~ 'NW, Noord, ZO, Weesp')
  )


ms_long<- ms |>
  pivot_longer(cols= c(normalised_euros:corrected_transactions)) |>
  pivot_longer(cols = c(jaar, jaar_kwartaal, jaar_maand, jaar_week ), names_to = "tijd_type", values_to = "datum") |>
  
  filter(sector %in% c("Detailhandel dagelijks"  , 
                       "Detailhandel niet-dagelijks: mode" ,  
                       "Detailhandel niet-dagelijks: Overig", 
                       "Restaurant-cafés" ))
    



# staafdiagram figuur 





my_plot_staaf <- function(x, sd,  tijd, waarde, branche, xmin, xmax){
  
  
  wild_pal <- c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000")
  
   x|>
     filter(sector %in% branche,
            name == waarde,
            tijd_type == tijd) |>
     
     group_by(sector, tijd_type, datum, locatie, name, herkomst) |>
     
     summarise(value=sum(value, na.rm = T)) |>
     mutate(tooltip= glue:: glue("{datum} \n
                                      {sector} \n
                                      {locatie} \n
                                      {format(round(value, 2), big.mark = '.', decimal.mark= ',' , scientific = F)}"))  |>
     
     ggplot(aes(x= datum ,y= value, fill = sector, tooltip = tooltip, data_id = value )) +
     geom_col_interactive()+
     labs(title=NULL, x=NULL,y = NULL) +
     scale_fill_manual(name= NULL, values = wild_pal) +
     guides(fill = guide_legend(nrow = 2, reverse = T))+
     xlim(xmin, xmax) +
     facet_wrap( ~ locatie + fct_rev(herkomst), ncol=2, strip.position = 'left')+
     theme_bw() +
     theme(
       axis.text = element_text(family = font),
       plot.caption = element_text(family = font),
       axis.title = element_text(family = font, hjust = 1),
       plot.subtitle = element_text(family = font),
       legend.text = element_text(family = font),
       plot.title = element_text(family = font, lineheight = 1.2),
       panel.grid.minor = element_blank(),
       strip.background = element_blank(),
       legend.title=element_blank(),
       axis.ticks.y = element_blank(),
       axis.ticks.x = element_blank(),
       legend.position='bottom',
       panel.border = element_rect(fill = "transparent", color = NA),
       strip.text = element_text(family = font)
       
     ) 
}

save( ms_long, my_plot_staaf, file = "ms_shiny_staaf.RData")


# # # #### test 
# ms_long |>
#   my_plot_staaf (
#            #sd = c("Centrum", 'NW, Noord, Zuidoost, Weesp'),
#            tijd= "jaar_kwartaal",
#            waarde  = "normalised_euros",
#            branche = c("Detailhandel niet-dagelijks: mode", "Detailhandel niet-dagelijks: Overig" ),
#            xmin= ms_long$datum["2018-12-01"],
#            xmax= ms_long$datum["2023-01-01"])



  

  

