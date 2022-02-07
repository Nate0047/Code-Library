# SET LIBRARY PATH -------------------------------------------------------------
# set librarby to avoid Onedrive:
.libPaths("C:/R library")
.libPaths()


# INSTALL PACKAGES AND ORGANISE LIBRARY ----------------------------------------
if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)


## READ IN DATA ----------------------------------------------------------------

# Create list of files that need to be dataframes
data_files <- gsub("*.csv$", "", list.files(pattern = "*.csv$"))

# Create for loop to read in files
for(i in data_files){
  assign(i, read.csv(paste(i, ".csv", sep = "")))
}
# Above loop reads each item in 'data_files' list and assigns itself,
# it reads the CSV which automatically creates a df, 
# then pastes it's listed name onto the df, 
# before then looping to the next i in the list. 
