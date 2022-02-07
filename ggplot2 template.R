## SET LIBRARY PATH ############################################################
#set librarby to avoid Onedrive:
.libPaths("C:/R library")
.libPaths()
#now should show as: "C:/R library".

## INSTALL PACKAGES AND ORGANISE LIBRARY #######################################
if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)

## DATA IMPORT #################################################################
ggplot2::mpg #dataframe for practice available in ggplot package
?mpg #provides overview of dataframe
#of interest - displacement & highway mpg
glimpse(mpg)

## VISUALS - MAPPING INSIDE GEOMS (LOCAL MAPPING) ##############################
#create visualisation of displ & hwy:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(position = "jitter") +
  geom_smooth()
#in addition to mapping class to colour, could also map to alpha (transp) or 
#shape (shapes). Eg.,
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#Next apply facet_wrap to create sub-plots of discrete variables:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class)
?facet_wrap
#Can also add 2 discrete variables to the data using facet_grid:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(cyl ~ class)
?facet_grid
#change geom to line as opposed to points:
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) + #forms line
  geom_point(mapping = aes(x = displ, y = hwy))    #forms points
#add colour command to aes seperates and then colours in one go:
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, colour = drv),
              show.legend = FALSE)

## VISUALS - GLOBAL MAPPING ####################################################
#place mapping command in first line of code:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()
#this allows for manipulation of local geoms individually:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth()

## DATA TRANSFORMATIONS ########################################################
#Using diamonds dataset from ggplot2:
?diamonds
ggplot(data = diamonds, mapping = aes(x = cut)) +
  geom_bar()
#stat transformation occurs here as 'count' on y is not a variable. It is
#created by R when plotting the bar chart
#use of stat-summary allows manipulation of data within visualisation:
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) +
  stat_summary(fun.min = min,
               fun.max = max,
               fun = median)
#many stat functions available: 
?stat_bin
#can colour bar charts based on discrete variables:
#colour puts outline, but 'fill' fills the bar with colour:
ggplot(data = diamonds, mapping = aes(x = cut)) +
  geom_bar(mapping = (aes(fill = cut)))
#is powerful when you are wanting to examine variable with bars:
#also add position "fill" to make bars all same size:
ggplot(data = diamonds, mapping = aes(x = cut)) +
  geom_bar(mapping = aes(fill = clarity), position = "dodge")
#position = "jitter", adds noise back to scatterplot
?position_jitter
?geom_count

## COORDINATE SYSTEMS ##########################################################
#many ways to specify plot behaviour:
#coord_flip can flip x and y axes:
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
#then flipped:
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()
?map_data
#build polar chart:
ggplot(data = diamonds, mapping = aes(x = cut, fill = cut)) +
  geom_bar(width = 1) +
  coord_polar()
#Quiz:
?geom_abline
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

## OVERALL TEMPLATE FOR GGPLOT #################################################
#Best example of ggplot functions:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>
