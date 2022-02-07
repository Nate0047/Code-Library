# SET LIBRARY PATH TO AVOID ONEDRIVE -------------------------------------------
# First set library so OneDrive does not copy everything:
.libPaths("C:/R library")
.libPaths()
# now should show as: "C:/R library".

# INSTALL PACKAGES AND ORGANISE LIBRARY ----------------------------------------
if(!require("tidyverse")) {install.packages("tidyverse")}
library(dplyr)
library(tidyr)
library(readxl)
library(readr)
library(ggplot2)
library(tibble)
library(readxl)
if(!require("stm")) {install.packages("stm")}
library(stm)


# Published paper to assist:
# Roberts, Margaret E., Brandon M. Stewart, and Dustin Tingley.//
# //"Stm: An R package for structural topic models." //
# //Journal of Statistical Software 91.1 (2019): 1-40.


# IMPORT DATA -------------------------------------------------------------------
raw_data <- data.frame(read.csv("<datafile>.csv"))
head(raw_data)
# Q8 is text data.


##INGEST DATA##
processed <- textProcessor(raw_data$Q8, 
                           metadata = raw_data, 
                           removenumbers = FALSE)
#numbers retained as 101 and 999 may appear as terms. 
out <- prepDocuments(processed$documents, 
                     processed$vocab, 
                     processed$meta)
docs <- out$documents
vocab <- out$vocab
meta <- out$meta
#results in a corpus of 2853 docs. - re-indexed.


# PREPARE DATA ----------------------------------------------------------------
# Can plot how many documents, words and tokens would be removed when setting//
# minimum threshold for number of infrequent words.
plotRemoved(processed$documents, 
            lower.thresh = seq(1, 100, by = 1))

# set minimum threshold of word frequency:
out <- prepDocuments(processed$documents, 
                     processed$vocab, 
                     processed$meta, 
                     lower.thresh = 10)
# remove 17 documents and 2842 of 3099 words (9406 of 26223 tokens).


# SEARCH FOR 'BEST' K ------------------------------------------------------------
Ksearch <- searchK(out$documents, 
                   out$vocab, 
                   K = c(2:50), 
                   prevalence =~ Method, 
                   data = out$meta)
Ksearch
plot(Ksearch) #residuals best between 19-24. 19 had low holdout, but 22 did 'well'.
# Overall from examining plot, K = 22 was selected. 


# ESTIMATE MODEL -----------------------------------------------------------------
# K = established by Ksearch = 22.
stm_Spectral_Fit <- stm(documents = out$documents, 
                        vocab = out$vocab, 
                        K = 22,
                        max.em.its = 75, 
                        data = out$meta, 
                        init.type = "Spectral")

# UNDERSTAND ---------------------------------------------------------------------
# provide words in each topic:
labelTopics(stm_Spectral_Fit, n = 10) # use FREX in future
# can plot these too:
plot.STM(stm_Spectral_Fit, type = "labels", n = 10, width = 100)
# drilling down into individual quotes:
# prep document data:
x <- as.data.frame(out$meta)
thoughts1 <- findThoughts(stm_Spectral_Fit, 
                          text = x$Q8, 
                          n = 20, 
                          topics = 18)
plotQuote(thoughts1, width = 100, main = "Specific Police Issues")


# VISUALISE -----------------------------------------------------------------------
# visualise correlation between all of the topics:
topic_correlates <- topicCorr(stm_Spectral_Fit)
plot(topic_correlates)
# proportion of each topic across sample:
plot.STM(stm_Spectral_Fit, type = "summary")
# wordclouds for individual topics:
cloud(stm_Spectral_Fit, topic = 5)
# example quotes:
quotes <- findThoughts(stm_Spectral_Fit, text = x$Q8, n = 20, topics = 5)
plotQuote(quotes, width = 100, main = "topic 5")
# Compare words across two topics
plot(stm_Spectral_Fit, type = "perspectives", topics = c(5, 8))


# INTERPRET AND REPORT --------------------------------------------------------------

# CAN ALSO WRITE OUT FILE WITH TOPIC THETA ------------------------------------------
export_topics <- make.dt(stm_Spectral_Fit, meta = out$meta)
head(export_topics) #retained all meta next to topics and theta scores
write_excel_csv(export_topics, "[enter file path"])
# can use this for PowerBI follow up with analysts
