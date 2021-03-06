## SET LIBRARY -----------------------------------------------------------------
#avoiding Onedrive:
.libPaths("C:/R library")
.libPaths()
#now shows as: "C:/R library"

## PACKAGES - INSTALL AND LIBRARY ----------------------------------------------
if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)
if(!require("lubridate")) {install.packages("lubridate")}
library(lubridate)
if(!require("rvest")) {install.packages("rvest")}
library(rvest)

## WEBSCRAP PRACTICE -----------------------------------------------------------
#use xpath or css to get to html elements in webpages:
#Want to scrape lego movie song list from wikipedia:
#URL = https://en.wikipedia.org/wiki/The_Lego_Movie
#support from xpath website - https://www.w3schools.com/xml/xpath_syntax.asp
LegoMovieWebpage <- rvest::read_html("https://en.wikipedia.org/wiki/The_Lego_Movie")
#using xpath //finds node anywhere on page [introduce further info @ is 
#an attribute of that node]:
Tracklist <- html_element(LegoMovieWebpage, xpath = '//table[@class = "tracklist"]')
Tracklist.df <- data.frame(
  Tracklist %>%
    html_table()
)
View(Tracklist.df)

