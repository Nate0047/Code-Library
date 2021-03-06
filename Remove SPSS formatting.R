# SETUP, PACKAGES, LIBRARY -----------------------------------------------------

# set lib path
.libPaths("C:/R library")

# packages and library
if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)
if(!require("sjlabelled")) {install.packages("sjlabelled")}
library(sjlabelled)
if(!require("sjPlot")) {install.packages("sjPlot")}
library(sjPlot)

# IMPORT DATA -------------------------------------------------------------------

# read in SMSR data - assign to data_import
spss_import <- haven::read_sav("<data>.sav")

# filter to only key vars
spss_import <-
  spss_import %>%
  select(<variables>)

# remove all spss attributes
# spss_import[] <- lapply(spss_import, function(x) {attributes(x) <- NULL;x})

# rename cols
spss_import <-
  spss_import %>%
  rename(<vars>)

# view all SPSS labels
sjPlot::view_df(spss_import)

# transfer coding of labels to raw data
data_export <-
  spss_import %>%
  mutate(<vars> = haven::as_factor(vars))

# remove all other info
data_export <-
  data_export %>%
  haven::zap_formats() %>%
  haven::zap_label() %>%
  haven::zap_widths()

# write out to a csv
write.csv(data_export, "ElderAI.test - Survey.csv")





