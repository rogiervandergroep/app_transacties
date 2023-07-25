

### basis ---
source("helpers.R")  #libraries
source("tooltip_css.R") #tooltip css

if(!exists("os_tools")) {
  source("http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R")
}


# Load data ---
ms     <- read.xlsx("../transactiedata/levering 7 tm 1 juli 2023/xlsx/Mastercard_sector7_week_wijk.xlsx")


ms$week<- str_pad(ms$week, side = "left", width = 2, pad = 0)
ms$date <- glue ("{ms$year}-W{ms$week}-5")

ms$jaar_week     <- date(ISOweek2date(ms$date))
ms$jaar_maand    <- floor_date(ms$jaar_week, unit= 'month')
ms$jaar_kwartaal <- quarter(ms$jaar_week, type="date_first")
ms$jaar          <- floor_date(ms$jaar_week, unit = 'year')

# zevenlandenindeling verwijderd, wijken verwijderd, stadsdelen toegevoegd -
groupvar<- c("sector",
             "sector_indeling" ,
             "sd_code",
             "sd_naam",
             "date",
             "jaar_week",    
             "jaar_maand", 
             "jaar_kwartaal",
             "jaar",
             "herkomst" ) 

waarden <- c("normalised_euros",
             "normalised_transactions",
             "corrected_euros",
             "corrected_transactions") 

# optellen: Nederland versus buitenland - wijken naar stadsdelen -
ms_herkomst_sd <- ms |>
  
  mutate(
    
    herkomst=case_when(
      zeven_landen_indeling == 'Continent: Europa Nederland' ~ 'Nederland',
      TRUE ~ 'Buitenland'),
      
    sd_code=str_sub(gebied_code, 1,1),
      
    sd_naam =case_when(
      sd_code == "A" ~ "Centrum",
      sd_code == "B" ~ "Westpoort",
      sd_code == "E" ~ "West",
      sd_code == "F" ~ "Nieuw-West",
      sd_code == "K" ~ "Zuid",
      sd_code == "M" ~ "Oost",
      sd_code == "N" ~ "Noord",
      sd_code == "S" ~ "Weesp",
      sd_code == "T" ~ "Zuidoost",
      TRUE ~ NA)
  ) |>
  
  group_by(pick(groupvar)) |>
  
  summarise(across(all_of(waarden), ~ sum(.)))


ms_long<- ms_herkomst_sd |>
  pivot_longer(cols= c(normalised_euros:corrected_transactions)) |>
  pivot_longer(cols = c(jaar, jaar_kwartaal, jaar_maand, jaar_week ), names_to = "tijd_type", values_to = "datum") |>
  
  filter(sector %in% c("Detailhandel dagelijks"  , 
                       "Detailhandel niet-dagelijks: mode" ,  
                       "Detailhandel niet-dagelijks: Overig", 
                       "Restaurant-cafés" ))
    




save(ms_long, file = "ms_shiny_map.RData")



