# SET LIBRARY FILEPATH ----------------------------------------------------
.libPaths("C:/R library")

# PACKAGES AND LIBRARY -----------------------------------------------------
# need ROUTINE DATA QUALITY ASSESSMENT (RQDA) tool for qualitative analysis:
# is it possible to install RQDA for qualitative analysis on R4.1:
install.packages("RQDA") #Not supported on 4.0 - need a work around.

# forums dedicated to getting this working. But bespoke package available:
# https://github.com/BroVic/RQDAassist

# package developed to assist installation of RQDA:
devtools::install_github("BroVic/RQDAassist")
1
library(RGtk2) #needs user interaction
RQDAassist::install()

#package stated installed RQDA successfully.

library(RQDA)
# use RQDA() to begin using programme
RQDA()
# this works as intended