if(!require("summarytools")) {install.packages("summarytools")}
library(summarytools)

summary(<df>) # describes data in console

freq(<df$var>, plain.ascii = FALSE, style = "rmarkdown") # provides a table of description

view(dfSummary(<df>, plain.ascii = FALSE, style = "grid")) # provides a plot of descriptive output

Link for more detailed functions:
  https://cran.r-project.org/web/packages/summarytools/vignettes/introduction.html