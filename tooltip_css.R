

# kleurenwijzen os
# https://os-amsterdam.gitlab.io/datavisualisatie-onderzoek-en-statistiek/

# install.packages("gfonts")
library(gfonts)

# get_all_fonts()

# setup_font(
#   id = "roboto",
#   output_dir = "www")

use_font("roboto", "www/css/roboto.css")

### default settings ggiraph

font <- "roboto"  
bg_color <- "black"
font_color <- "white"
hover_color <- "#009dec"
inv_hover_color <- "#e7e7e7"

tooltip_css           <- glue("background-color:{bg_color};color:{font_color};font-weight:400;font-family:{font};padding:10px")
tooltip_css_hover     <- glue("fill:{hover_color};stroke-width:1.5px")
tooltip_css_inv_hover <- glue("fill:{inv_hover_color};stroke-width:1.5px")

set_girafe_defaults(
  opts_hover    = opts_hover    (css = tooltip_css_hover),
  opts_hover_inv= opts_hover_inv(css = tooltip_css_inv_hover), 
  opts_zoom     = opts_zoom     (min = .7, max = 3),
  opts_tooltip  = opts_tooltip  (css = tooltip_css),
  opts_toolbar  = opts_toolbar  (saveaspng = T, position = "topleft", delay_mouseout = 5000),
  opts_sizing   = opts_sizing   (rescale = TRUE))