# LIBRARY AND PACKAGES ---------------------------------------------------------
.libPaths("C:/R library")

if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)
library(magrittr)

# READ IN NVIVO CODES ----------------------------------------------------------

# read in Nvivo theme coding matrix
Nvivo_themes <- read_xlsx("<file location>")

# split nvivo ID from main ID and drop nvivo ID
Nvivo_themes <- separate(data = Nvivo_themes, 
                         col = <column name>, 
                         into = c("nvivoID", "ID"), 
                         sep = ":")

Nvivo_themes %<>%
  select(-nvivoID) # drop Nvivo ID

Nvivo_themes$ID <- as.numeric(Nvivo_themes$ID)


# If mixed methods - join nvivo themes to main df
import_completecases <- left_join(import_completecases, Nvivo_themes, by = "ID")

View(import_completecases)
