#First set library so OneDrive does not copy everything:
.libPaths("C:/R library")
.libPaths()
#now shows as: "C:/R library"

#BEFORE ANY INSTALL! SET LIBRARY TO AVOID ONEDRIVE! (see above):
if(!require("tidyverse")) {install.packages("tidyverse")}
library(dplyr)
library(tidyr)
library(readxl)
library(readr)
library(ggplot2)
library(tibble)
library(readxl)
#library(xlsx)
if(!require("tidytext")) {install.packages("tidytext"); library("tidytext")}
if(!require("quanteda")) {install.packages("quanteda"); library("quanteda")}
if(!require("readtext")) {install.packages("readtext"); library("readtext")}
if(!require("RColorBrewer")) {install.packages("RColorBrewer"); library("RColorBrewer")}
theme_set(theme_bw())
if(!require("quanteda.textstats")) {install.packages("quanteda.textstats"); library("quanteda.textstats")}
if(!require("wordcloud")) {install.packages("wordcloud"); library(wordcloud)}
#if(!require("wordcloud2")) {install.packages("wordcloud2"); library(wordcloud2)} #more complex wordclouds.
if(!require("readtext")) {install.packages("readtext"); library("readtext")}

#BEGIN:

#Of note, with text analysis you will want to read in a corpus first. This will//
#//be the main datasource wigh attached meta-data. From there you can create//
#//several DFM's (see later) to analyse the data. The DFMs are like a 'bag of//
#//words without positional information. Corpus holds all of that.


#IMPORT DATA:

#<read in data <- import>


#DIVIDE INTO TRAIN AND TEST DATA:
set.seed(1) # 'Set seed' sets starting point of sample split to replicate split.
# Now Selecting 90% of data as sample from total 'n' rows of the data. 
splitdata <- sample.int(n = nrow(import), size = floor(.90*nrow(import)), replace = FALSE)
#Then assign test and training data for import using the datasplit.
train <- import[-splitdata, ]
test  <- import[splitdata, ]
rm(splitdata)

#CREATE CORPUS:

#This code reads in a corpus with metadata from the 'maindata'.dataframe.
corpus <- corpus(
  import,
  docid_field = "ID",
  text_field = "Q8",
  meta = list(),
  unique_docnames = TRUE)
rm(import)
#This has created corpus using Q8 as data, and other variables are docvars.
head(docvars(corpus))
#Can add to the metadata by using doc vars if needed, e.g:
#docvars(corpus, "variables name") <- maindata$variable name

#Provide overview of words, sentences etc within the corpus:
#Of note, function 'summary' defaults to n = 100. Needed to manually change to larger sample.
Textoverview <- summary(corpus, n = 4650, tolower = FALSE, showmeta = TRUE)
View(Textoverview)
#Can plot these in different ways to understand the 'texture' of the qual data:
ggplot(Textoverview, aes(Text, Tokens, group = 1)) + geom_line() + geom_point() + ggtitle("Tokens per person") + xlab("ID") + ylab("Total no. of words")
ggplot(Textoverview, aes(Tokens, Types, group = 1, label = Text)) + geom_smooth(method = "lm", se = FALSE) + geom_text(check_overlap = F) + ggtitle("Type-Token-Ratio (TTR) per respondent")
rm(Textoverview)
#Can filter through the corpus using [] to denote respondent.
corpus_sample(corpus, size = 1) #provides random participant (and their ID).
str_sub(corpus[3], start = 1, end = 10000) #used posisition to bring up their full text.


#TOKENISATION:

#Tokenisation, break down each individual word for each ID:
my.tokens <- tokens(corpus) #list of 4611 elements (all words/tokens)
head(my.tokens)
#Can also set more than one word strings:
ngram5 <- tokens_ngrams(my.tokens, n = 5)
head(ngram5)
rm(ngram5)
#Seems to not select ngrams. potential bug? NOPE:
#Cannot call ngrams directly on corpus. Need to create list of tokens and then//
#//run the function on tokens list... duh!


#CREATE DFMs:

#Build corpus into DFM - Document feature matrix (or matrices)
q8dfm <- dfm(my.tokens, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE, remove = stopwords("english"))
rm(corpus)
rm(my.tokens)
#Now just handling the dfm:
head(q8dfm)
ndoc(q8dfm) #returns info on how many participants there are. 
nfeat(q8dfm) #returns info on how many unique words. 
featnames(q8dfm)
#Bring up most frequently used term for first 10 respondents(/document):
head(dfm_sort(q8dfm, decreasing = TRUE, margin = "both"), n = 10) 

#Create list of words in order of frequency:
#First stem words to be more precise:
q8dfm <- dfm_wordstem(q8dfm, language = "english")

#BETTER CODE THAN TOPFUNCTION - To do this, but retain the uniqueness of respondents, then//
#//use textstat_functions. This is preferred to topfeatures funtion.
#if(!require("quanteda.textstats")) {install.packages("quanteda.textstats"); library("quanteda.textstats")}
totalfreq <- textstat_frequency(q8dfm) #Much better output of frequency list. 
View(totalfreq) #provides list overview.

#For developing wordclouds with this info:
# if(!require("wordcloud")) {install.packages("wordcloud"); library(wordcloud)}
# if(!require("wordcloud2")) {install.packages("wordcloud2"); library(wordcloud2)} # use for more complex designs
wordcloud(words = totalfreq$feature, freq = totalfreq$docfreq, min.freq = 3, max.words = 1000, random.order = FALSE, res = 1000, rot.per=.15, colors = brewer.pal(8, "Dark2"))
#Need to make 'plots' window bigger to fit wordcloud, otherwise it gets crushed.
#Can then export the wordcloud for reports.
rm(q8dfm, totalfreq)


#CONCORDANCES:

#Search for a word 'within' the context it is from (default window = 5 words eitherside).
#Refer back to the corpus:
concordance <- kwic(corpus, "media") #Search specific words.
concordance <- kwic(corpus, ("facebook"), window = 10, case_insensitive = TRUE) #with boolean.
concordance <- kwic(corpus, c("anti-social*", "polic*"), window = 10, case_insensitive = FALSE) #multiple terms.
View(concordance)


#COLLOCATIONS:

#search for words that occur most often with search term.
my.tokens <- tokens(corpus)
collocations <- textstat_collocations(my.tokens, min_count = 10)
#Then can be arranged in either count form:
tokcount <- arrange(collocations, desc(count))
View(tokcount)
rm(tokcount)
#or by distance:
toklam <- arrange(collocations, desc(lambda))
View(toklam)
rm(toklam)
View(q8dfm)


#KEYNESS:

#Can compare measure distinctiveness of terms in big text (or group) when//
#//in comparison to other texts  (or groups).
keyness <- textstat_keyness(q8dfm, target = "1", measure = "lr")
View(keyness)
textplot_keyness(keyness)


#LEXICAL DIVERSITY:

#Provides metrics on how complex each response is in terms of token/type relation.
lex.diversity <- textstat_lexdiv(q8dfm, measure ="all")
View(lex.diversity)

# concordances are not really a word metric, but can be useful to assess material
# there exists a big toolbox of similary and distance measures to examine both words and texts
# collocations and keyness are convient measures for finding words that are similar (to other words) and that are distinct (for certain texts, relative to all other texts)
# lexical diversity and readibility can act as proxies for textual complexity

