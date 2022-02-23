# SETUP, PACKAGES, LIBRARY -----------------------------------------------------

# set lib path
.libPaths("C:/R library")

# packages and library
if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)
if(!require("rgdal")) {install.packages("rgdal")}
library(rgdal) # for reading in shape file
if(!require("rgeos")) {install.packages("rgeos")}
library(rgeos) # for fixing error related to gpclib
if(!require("broom")) {install.packages("broom")}
library(broom) # for tidying file for ggplot2


# READ IN MAP ------------------------------------------------------------------

# shapefiles for UK police forces on ONS Geospatial portal, available at:
# https://geoportal.statistics.gov.uk/datasets/ons::police-force-areas-december-2016-full-clipped-boundaries-in-england-and-wales-1/about
# have selected and downloaded shp file option

# load shapefile
shapefile <- readOGR(dsn = "Police_Force_Areas_December_2016_EW_BFC_v2-shp",
                     layer = "Police_Force_Areas_December_2016_EW_BFC_v2")

# reshape data for ggplot
police_map <- tidy(shapefile, region = "PFA16NM")

# plot these boundaries in ggplot
ggplot() +
  geom_polygon(data = police_map, aes(x = long, y = lat, group = group), colour = "#FFFFFF", size = 0.25) +
  coord_fixed(1)


# CREATE HEATMAP ---------------------------------------------------------------

# build heatmap of forces for some fictitious thing

# create random data against names of forces
external_data <- police_map %>%
  distinct(id)
random_number <- floor(runif(43, min = 0, max = 100))
external_data <- data.frame(external_data, random_number)
rm(random_number)

# join external data to map data
police_map <- left_join(police_map, external_data, by = "id")

# plot the heatmap
ggplot() +
  geom_polygon(data = police_map, aes(x = long, y = lat, group = group, fill = random_number), colour = "#FFFFFF", size = 0.25) +
  coord_fixed(1) + 
  theme_void()

