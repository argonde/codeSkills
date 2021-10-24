#!/usr/bin/R

# Purpose- Get Twitter data on a business xFoss and its followers in order
# to perform an attitude analysis, and visualising the data for comparison
###################################################################################
## STEP1 - get followers
###################################################################################

# Twitter API credentials
consumer_key <- "consumer_key"
consumer_secret <- "consumer_secret"
access_token <- "your-access_token"
access_token_secret <- "your_access_token_secret"

# Load library and handshake to Twitter API
if (!require(twitteR)){install.packages("twitteR")}
library(twitteR)
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_token_secret)

# Script for graphing Twitter followers
if (!require(igraph)){install.packages("igraph")}
library(igraph)

# Set working directory
setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")

# Get User Information with twitteR function getUser()
xFoss <- getUser("xfoss")

# Get follower names by fetching their IDs (getFollowerIDs())
# and then looking up their names (lookupUsers())

follower.object <- lookupUsers(xFoss$getFollowerIDs())

# Retrieve the follower's names from the object.
# Adjust the size of the selected data with [1:n], else the maximum number of
# friends and/or followers will be visualized.
n <- 1000
followers <- sapply(follower.object[1:n], name)
write.csv(followers, file = "D:/path/to/R/_dataSets/tweets/xFollowers.csv",
          row.names = F)

# Step clean up
rm(list = c('xFoss', 'follower.object', 'n', 'followers'))

###################################################################################
## STEP2 - get tweets
###################################################################################

# Get xfoss tweets_______________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/txfoss")
(tweets <- searchTwitter('xfoss', n=1000, lang='en'))
tweetsxf <-twListToXF(tweets)
write.csv(tweetsxf, file = "xfossTw1000.csv", row.names = F)


# Get follower tweets______________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/")
followers <- "xFollowers.csv"
conn <- file(followers,open="r")
setwd("D:/path/to/R/_dataSets/tweets/tFollowers")
linn <- readLines(conn)
for (i in 1:length(linn)){
  nm <- print(linn[i])
  feed <- searchTwitter(nm, n=120, lang='en')
  flines <- length(feed)
  if (flines < 15){
    next
  }
  else {
    tweets <-twListToXF(feed)
    write.csv(tweets, file = linn[i], row.names = F)
  }
}


# Twitter trends___________________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/")
trend <- availableTrendLocations()
trendsDk <- getTrends(23424796)  #get trends in Denmark
write.csv(trendsDk, file = "trendsDk.csv", row.names = F)

# User time line
(t <- getUser('xfoss'))
userTimeline(t, n=2)

# Step clean up
rm(list = c('consumer_key', 'consumer_secret', 'access_token', 'access_token_secret',
            'tweets', 'tweetsxf', 'feed', 'trend', 'trenDk', 't', 'followers', 'conn',
            'i', 'linn', 'nm'))

###################################################################################
## STEP3 - Attitude Analysis
###################################################################################

# Read file
XFfeed <- read.csv("D:/path/to/R/_dataSets/tweets/txfoss/xfossTw1000.csv")
str(XFfeed)

# Build corpus of tweets
if (!require(tm)){install.packages("tm")}
library (tm)
setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")

corpus <- iconv(XFfeed$text, to = 'utf-8')
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])

# Clean the text
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
#corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, (stopwords('english')))
inspect(corpus[1:5])
# Remove repeated morphems
corpus <- tm_map(corpus, gsub, pattern = "\n", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "â€¦", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "http", replacement = " ")

# Term document matrix
(tdm <- TermDocumentMatrix(corpus))
tdm <- as.matrix(tdm)
#(tdm[1:10, 1:10])


# Corpus visualisations_________________________________________________________
  # Bar plot
x <- rowSums(tdm)
x <- subset(x, x>=20)
if (!require(ggplot2)){install.packages("ggplot2")}
library(ggplot2)
barplot(x, las=2)
  # word cloud
if (!require(wordcloud)){install.packages("wordcloud")}
library(wordcloud)
x <- sort(rowSums(tdm), decreasing = T)
set.seed(222)
wordcloud(words = names(x),
          freq = x,
          max.words = 150,
          random.order = F,
          min.freq = 7,
          colors = brewer.pal(12, "Paired"),
          scale = c(6, 0.2),
          rot.per = 0.4)


# Attitude analysis_____________________________________________________________
if (!require(syuzhet)){install.packages("syuzhet")}
if (!require(lubridate)){install.packages("lubridate")}
if (!require(scales)){install.packages("scales")}
if (!require(reshape2)){install.packages("reshape2")}
if (!require(dplyr)){install.packages("dplyr")}

library(syuzhet)
library(lubridate)
library(scales)
library(reshape2)
library(dplyr)

#xfoss <- read.csv(file.choose(), header = T)
tweets <- iconv(XFfeed$text, to = 'utf-8')

# Obtain attitude scores
a <- get_nrc_sentiment(tweets)
head(a)
tweets[5]
get_nrc_sentiment('delay')
write.csv(a, file = "attxfoss.csv", row.names = F)

# Visualisations
barplot(colSums(a),
        las = 2,
        col = brewer.pal(12, "Paired"),
        ylab = 'Count',
        main = 'Attitude Scores for xfoss')

# Step clean up
rm(list = c('a', 'XFfeed', 'corpus', 'tdm', 'x', 'xfoss', 'tweets'))

###################################################################################
## STEP4 - Merge Follower Tweets
###################################################################################

# Merge multiple files on a directory
if (!require(readr)){install.packages("readr")}  # for read_csv()
if (!require(tidyr)){install.packages("tidyr")}  # for unnest()
if (!require(purrr)){install.packages("purrr")}  # for map(), reduce()

library(readr)
library(tidyr)
library(purrr)

# Merge business data____________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/tFollowers/subSet_business")
files <- dir(pattern = "*.csv")

data <- files %>%
  map(read_csv) %>%    # read all files by function read_csv()
  reduce(rbind)        # reduce with rbind into one dataframe
data

setwd("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/")
write.csv(data, file = "tweetsBsMerged.csv", row.names = F)


# Merge private data_____________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/tFollowers/subSet_private/prvt01")
files <- dir(pattern = "*.csv")

data <- files %>%
  map(read_csv) %>%    # read all files by function read_csv()
  reduce(rbind)        # reduce with rbind into one dataframe
data

setwd("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/")
write.csv(data, file = "tweetsPrMerged.csv", row.names = F)


# Merge others data______________________________________________________________
setwd("D:/path/to/R/_dataSets/tweets/tFollowers/subSet_private/prvt02")
files <- dir(pattern = "*.csv")

data <- files %>%
  map(read_csv) %>%    # read all files by function read_csv()
  reduce(rbind)        # reduce with rbind into one dataframe
data

setwd("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/")
write.csv(data, file = "tweetsOrMerged.csv", row.names = F)


# Step clean-up
rm(list = c('files', 'data'))

###################################################################################
## STEP5 - Followers Attitude Analysis
###################################################################################
#_________________________________BUSINESS_____________________________________
# Read file business followers
BSfeed <- read.csv("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/tweetsBsMerged.csv")
str(BSfeed)

setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")

# Build Corpus
corpus <- iconv(BSfeed$text, to = 'utf-8')
corpus <- Corpus(VectorSource(corpus))
#inspect(corpus[1:5])

# Clean the text using tm package
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
#corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, (stopwords('english')))
#inspect(corpus[1:5])
# remove repeated morphems
corpus <- tm_map(corpus, gsub, pattern = "\n", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "â€¦", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "http", replacement = " ")
corpus <- tm_map(corpus, removeWords, c("amp", "mikequindazzi", "gtgt"))

# Term document matrix
(tdm <- TermDocumentMatrix(corpus))
tdm <- as.matrix(tdm)
#(tdm[1:10, 1:10])


# corpus visualisations_________________________________________________________
  # Bar plot from library ggplot2
x <- rowSums(tdm)
x <- subset(x, x>=100)
barplot(x, las=2)
  # word cloud
x <- sort(rowSums(tdm), decreasing = T)
set.seed(500)
wordcloud(words = names(x),
          freq = x,
          max.words = 150,
          random.order = F,
          min.freq = 3,
          colors = brewer.pal(12, "Paired"),
          scale = c(2, 0.1),
          rot.per = 0.4)


# Attitude analysis business____________________________________________________
tweets <- iconv(BSfeed$text, to = 'utf-8')

# obtain attitude scores
a <- get_nrc_sentiment(tweets)
write.csv(a, file = "attVector_xBSfollowers.csv", row.names = F)

# visualisations
barplot(colSums(a),
        las = 2,
        col = brewer.pal(12, "Paired"),
        ylab = 'Count',
        main = 'Attitude Scores for xfoss Business Followers')


#__________________________________PRIVATE_____________________________________
#______________________________________________________________________________

# Read file private followers
PRfeed <- read.csv("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/tweetsPrMerged.csv")
str(PRfeed)

# Build Corpus
setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")

corpus <- iconv(PRfeed$text, to = 'utf-8')
corpus <- Corpus(VectorSource(corpus))
#inspect(corpus[1:5])

# Clean the text
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
#corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, (stopwords('english')))
#inspect(corpus[1:5])
# remove repeated morphems
corpus <- tm_map(corpus, gsub, pattern = "\n", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "â€¦", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "http", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "thank", replacement = "thanks")
corpus <- tm_map(corpus, gsub, pattern = "thankss", replacement = "thanks")
corpus <- tm_map(corpus, removeWords, c("amp", "smith", "alex", "chris", "scott",
                                        "david", "james", "michael", "brian", "singh",
                                        "rafizi", "ben", "ian", "yang", "ramli",
                                        "martin", "armstrong"))
corpus <- tm_map(corpus, removeWords, c("sumishacna", "stephen", "jones", "chris",
                                        "tu0085", "john", "atkins", "itu0092s", "pkr",
                                        "sophie", "gerwen", "lawson", "100000",
                                        "donnelly", "jack"))
# Term document matrix
(tdm <- TermDocumentMatrix(corpus))
tdm <- as.matrix(tdm)
#(tdm[1:10, 1:10])


# corpus visualisations_________________________________________________________
# Bar plot
x <- rowSums(tdm)
x <- subset(x, x>=80)
barplot(x, las=2)
# word cloud
x <- sort(rowSums(tdm), decreasing = T)
set.seed(222)
wordcloud(words = names(x),
          freq = x,
          max.words = 150,
          random.order = F,
          min.freq = 10,
          colors = brewer.pal(12, "Paired"),
          scale = c(2, 0.2),
          rot.per = 0.4)


# Attitude analysis private_____________________________________________________
tweets <- iconv(PRfeed$text, to = 'utf-8')

# obtain attitude scores
a <- get_nrc_sentiment(tweets)
write.csv(a, file = "attVector_xPrfollowers.csv", row.names = F)

# visualisations
barplot(colSums(a),
        las = 2,
        col = brewer.pal(12, "Paired"),
        ylab = 'Count',
        main = 'Attitude Scores for xfoss private Followers')


#_____________________________________OTHER_______________________________________
#_________________________________________________________________________________

# Read file other followers
ORfeed <- read.csv("D:/path/to/R/_dataSets/tweets/tFollowers/_merged/tweetsOrMerged.csv")
str(ORfeed)

# Build Corpus
setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")

corpus <- iconv(ORfeed$text, to = 'utf-8')
corpus <- Corpus(VectorSource(corpus))
#inspect(corpus[1:5])

# Clean the text
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
#corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, (stopwords('english')))
#inspect(corpus[1:5])
# remove repeated morphems
corpus <- tm_map(corpus, gsub, pattern = "\n", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "â€¦", replacement = " ")
corpus <- tm_map(corpus, gsub, pattern = "http", replacement = " ")
corpus <- tm_map(corpus, removeWords, c("amp", "mikequindazzi", "gtgt", "su0085",
                                        "iu0085", "btstwt", "hallaboutafrica",
                                        "dagga", "jamie", "oliver", "masak"))

# Term document matrix
(tdm <- TermDocumentMatrix(corpus))
tdm <- as.matrix(tdm)
#(tdm[1:10, 1:10])


# corpus visualisations_________________________________________________________
# Bar plot
x <- rowSums(tdm)
x <- subset(x, x>=100)
barplot(x, las=2)

# word cloud
x <- sort(rowSums(tdm), decreasing = T)
set.seed(222)
wordcloud(words = names(x),
          freq = x,
          max.words = 150,
          random.order = F,
          min.freq = 10,
          colors = brewer.pal(12, "Paired"),
          scale = c(2, 0.2),
          rot.per = 0.4)


# Attitude analysis others______________________________________________________
tweets <- iconv(ORfeed$text, to = 'utf-8')

# obtain attitude scores
a <- get_nrc_sentiment(tweets)
write.csv(a, file = "attVector_xOrfollowers.csv", row.names = F)

# visualisations
barplot(colSums(a),
        las = 2,
        col = brewer.pal(12, "Paired"),
        ylab = 'Count',
        main = 'Attitude Scores for xfoss other Followers')


# Step clean up
rm(list = c('a', 'BSfeed', 'corpus', 'tdm', 'x', 'ORfeed', 'PRfeed', 'tweets'))

###################################################################################
## STEP6 - Apply Cosine Similarity
###################################################################################
setwd("D:/path/to/R/_dataSets/tweets/attAnalysis")


# cosine similarity
#d <- read.csv("attxfoss.csv", header = F)
d <- as.vector(c(0.1585976628, 0.4724540902, 0.0767946578, 0.1285475793, 0.4207011686,
                 0.1185308848, 0.2003338898, 0.7662771285, 0.2687813022, 1.0868113523))

#f <- read.csv("attxBsfollowers.csv", header = F)
#f <- as.vector(c(0.1769688232, 0.374301676, 0.111010993, 0.221481348, 0.2977112993,
#                 0.1839971166, 0.1742656334, 0.5170300955, 0.3852946477, 0.7920346008))
fBs <- as.vector(c(0.1915975885, 0.3918613414, 0.0821401658, 0.2449133384, 0.3108515448,
                   0.169743783, 0.1578749058, 0.5212886209, 0.3652976639, 0.9142803316))
fOr <- as.vector(c(0.1674749924, 0.3796605032, 0.1350409215, 0.2371930888, 0.3540466808,
                   0.1949075477, 0.1908153986, 0.5215216732, 0.3807214307, 0.8488936041))
fPr <- as.vector(c(0.2192109145, 0.3753687316, 0.2031710914, 0.2802359882, 0.3049410029,
                   0.2407817109, 0.1825221239, 0.5348451327, 0.5025811209, 0.7835545723))

#cosine similarity calculation
dprod <- d%*%fBs
lend <- sqrt((d[1]*d[1]) + (d[2]*d[2]) + (d[3]*d[3]) + (d[4]*d[4]) + (d[5]*d[5]) +
             (d[6]*d[6]) + (d[7]*d[7]) + (d[8]*d[8]) + (d[9]*d[9]) + (d[10]*d[10]))
lenfB <- sqrt((fBs[1]*fBs[1]) + (fBs[2]*fBs[2]) + (fBs[3]*fBs[3]) + (fBs[4]*fBs[4]) +
              (fBs[5]*fBs[5]) + (fBs[6]*fBs[6]) + (fBs[7]*fBs[7]) + (fBs[8]*fBs[8]) +
              (fBs[9]*fBs[9]) + (fBs[10]*fBs[10]))
cosSim_Bs <- dprod / (lend*lenfB)

dprod <- d%*%fOr
lenfO <- sqrt((fOr[1]*fOr[1]) + (fOr[2]*fOr[2]) + (fOr[3]*fOr[3]) + (fOr[4]*fOr[4]) +
              (fOr[5]*fOr[5]) + (fOr[6]*fOr[6]) + (fOr[7]*fOr[7]) + (fOr[8]*fOr[8]) +
              (fOr[9]*fOr[9]) + (fOr[10]*fOr[10]))
cosSim_Or <- dprod / (lend*lenfO)

dprod <- d%*%fPr
lenfP <- sqrt((fPr[1]*fPr[1]) + (fPr[2]*fPr[2]) + (fPr[3]*fPr[3]) + (fPr[4]*fPr[4]) +
              (fPr[5]*fPr[5]) + (fPr[6]*fPr[6]) + (fPr[7]*fPr[7]) + (fPr[8]*fPr[8]) +
              (fPr[9]*fPr[9]) + (fPr[10]*fPr[10]))
cosSim_Pr <- dprod / (lend*lenfP)


#_________________________________________________________________________________
#change to 4 dimensional xfoss vector
d <- as.vector(c(0.4724540902, 0.4207011686, 0.7662771285, 1.0868113523))
fBs <- as.vector(c(0.3918613414, 0.3108515448, 0.5212886209, 0.9142803316))
fOr <- as.vector(c(0.3796605032, 0.3540466808, 0.5215216732, 0.8488936041))
fPr <- as.vector(c(0.3753687316, 0.3049410029, 0.5348451327, 0.7835545723))

dprod <- d%*%fBs
lend <- sqrt((d[1]*d[1]) + (d[2]*d[2]) + (d[3]*d[3]) + (d[4]*d[4]))
lenfB <- sqrt((fBs[1]*fBs[1]) + (fBs[2]*fBs[2]) + (fBs[3]*fBs[3]) + (fBs[4]*fBs[4]))
cosSim_Bs <- dprod / (lend*lenfB)

dprod <- d%*%fOr
lenfO <- sqrt((fOr[1]*fOr[1]) + (fOr[2]*fOr[2]) + (fOr[3]*fOr[3]) + (fOr[4]*fOr[4]))
cosSim_Or <- dprod / (lend*lenfO)

dprod <- d%*%fPr
lenfP <- sqrt((fPr[1]*fPr[1]) + (fPr[2]*fPr[2]) + (fPr[3]*fPr[3]) + (fPr[4]*fPr[4]))
cosSim_Pr <- dprod / (lend*lenfP)

if (!require(scatterplot3d)){install.packages("scatterplot3d")}
library(scatterplot3d)
pts <- rbind(d, fBs, fOr, fPr)
scatterplot3d(pts[,1], pts[,2], pts[,3],
              xlab="Trust", ylab="Negativeness", zlab="positiveness",
              scale.y=1, axis=TRUE, angle=35, highlight.3d=TRUE, col.axis="blue",
              y.margin.add=0.3, lab.z=3,
              col.grid="grey", main="scatterplot3d - Attitudes", pch=20)


#_________________________________________________________________________________
#change to 3 dimensional vector
d <- as.vector(c(0.7662771285, 0.2687813022, 1.0868113523))
fBs <- as.vector(c(0.5212886209, 0.3652976639, 0.9142803316))
fOr <- as.vector(c(0.5215216732, 0.3807214307, 0.8488936041))
fPr <- as.vector(c(0.5348451327, 0.5025811209, 0.7835545723))

dprod <- d%*%fBs
lend <- sqrt((d[1]*d[1]) + (d[2]*d[2]) + (d[3]*d[3]))
lenfB <- sqrt((fBs[1]*fBs[1]) + (fBs[2]*fBs[2]) + (fBs[3]*fBs[3]))
cosSim_Bs <- dprod / (lend*lenfB)

dprod <- d%*%fOr
lenfO <- sqrt((fOr[1]*fOr[1]) + (fOr[2]*fOr[2]) + (fOr[3]*fOr[3]))
cosSim_Or <- dprod / (lend*lenfO)

dprod <- d%*%fPr
lenfP <- sqrt((fPr[1]*fPr[1]) + (fPr[2]*fPr[2]) + (fPr[3]*fPr[3]))
cosSim_Pr <- dprod / (lend*lenfP)

pts <- rbind(d, fBs, fOr, fPr)
scatterplot3d(pts[,1], pts[,2], pts[,3],
              xlab="Trust", ylab="Negativeness", zlab="positiveness",
              scale.y=1, axis=TRUE, angle=35, highlight.3d=TRUE, col.axis="blue",
              y.margin.add=0.3, lab.z=3,
              col.grid="grey", main="scatterplot3d - Attitudes", pch=20)


#_________________________________________________________________________________
#change to 2 dimensional vector
d <- as.vector(c(0.2687813022, 1.0868113523))
fBs <- as.vector(c(0.3652976639, 0.9142803316))
fOr <- as.vector(c(0.3807214307, 0.8488936041))
fPr <- as.vector(c(0.5025811209, 0.7835545723))

dprod <- d%*%fBs
lend <- sqrt((d[1]*d[1]) + (d[2]*d[2]))
lenfB <- sqrt((fBs[1]*fBs[1]) + (fBs[2]*fBs[2]))
cosSim_Bs <- dprod / (lend*lenfB)

dprod <- d%*%fOr
lenfO <- sqrt((fOr[1]*fOr[1]) + (fOr[2]*fOr[2]))
cosSim_Or <- dprod / (lend*lenfO)

dprod <- d%*%fPr
lenfP <- sqrt((fPr[1]*fPr[1]) + (fPr[2]*fPr[2]))
cosSim_Pr <- dprod / (lend*lenfP)

pts <- rbind(d, fBs, fOr, fPr)
plot(pts, main="Scatter Plot: negative vs. positive Attitudes",
     xlab="Negativeness", ylab="Possitiveness")


#_________________________________________________________________________________
#change to 3 dimensional inverse vector
d <- as.vector(c(0.1585976628, 0.0767946578, 0.2687813022))
fBs <- as.vector(c(0.1915975885, 0.0821401658, 0.3652976639))
fOr <- as.vector(c(0.1674749924, 0.1350409215, 0.3807214307))
fPr <- as.vector(c(0.2192109145, 0.2031710914, 0.5025811209))

dprod <- d%*%fBs
lend <- sqrt((d[1]*d[1]) + (d[2]*d[2]) + (d[3]*d[3]))
lenfB <- sqrt((fBs[1]*fBs[1]) + (fBs[2]*fBs[2]) + (fBs[3]*fBs[3]))
cosSim_Bs <- dprod / (lend*lenfB)

dprod <- d%*%fOr
lenfO <- sqrt((fOr[1]*fOr[1]) + (fOr[2]*fOr[2]) + (fOr[3]*fOr[3]))
cosSim_Or <- dprod / (lend*lenfO)

dprod <- d%*%fPr
lenfP <- sqrt((fPr[1]*fPr[1]) + (fPr[2]*fPr[2]) + (fPr[3]*fPr[3]))
cosSim_Pr <- dprod / (lend*lenfP)

pts <- rbind(d, fBs, fOr, fPr)
scatterplot3d(pts[,1], pts[,2], pts[,3],
              xlab="Anger", ylab="Disgust", zlab="Negativeness",
              scale.y=1, axis=TRUE, angle=35, highlight.3d=TRUE, col.axis="blue",
              y.margin.add=0.3, lab.z=3,
              col.grid="grey", main="scatterplot3d - Inverse Attitudes", pch=20)



# Step cleap-up
rm(list = c('cosSim_Bs', 'lenfB', 'lend', 'dprod', 'fBs', 'fOr', 'fPr', 'd',
'cosSim_Or', 'cosSim_Pr', 'pts'))

###################################################################################
## STEP7 - Calculate Difference in Vector Length
###################################################################################

setwd("D:/path/to/R/_dataSets/tweets/attAnalysis/differenceVector")


#input vectors
d <- as.vector(c(0.1585976628, 0.4724540902, 0.0767946578, 0.1285475793, 0.4207011686,
                 0.1185308848, 0.2003338898, 0.7662771285, 0.2687813022, 1.0868113523))

fBs <- as.vector(c(0.1915975885, 0.3918613414, 0.0821401658, 0.2449133384, 0.3108515448,
                   0.169743783, 0.1578749058, 0.5212886209, 0.3652976639, 0.9142803316))
fOr <- as.vector(c(0.1674749924, 0.3796605032, 0.1350409215, 0.2371930888, 0.3540466808,
                   0.1949075477, 0.1908153986, 0.5215216732, 0.3807214307, 0.8488936041))
fPr <- as.vector(c(0.2192109145, 0.3753687316, 0.2031710914, 0.2802359882, 0.3049410029,
                   0.2407817109, 0.1825221239, 0.5348451327, 0.5025811209, 0.7835545723))


#calcualte length of the difference vector
lend_fBs <- sqrt((d[1] - fBs[1])^2 + (d[2] - fBs[2])^2 + (d[3] - fBs[3])^2 +
                   (d[4] - fBs[4])^2 + (d[5] - fBs[5])^2 + (d[6] - fBs[6])^2 +
                   (d[7] - fBs[7])^2 + (d[8] - fBs[8])^2 + (d[9] - fBs[9])^2 +
                   (d[10] - fBs[10])^2)
lend_fOr <- sqrt((d[1] - fOr[1])^2 + (d[2] - fOr[2])^2 + (d[3] - fOr[3])^2 +
                   (d[4] - fOr[4])^2 + (d[5] - fOr[5])^2 + (d[6] - fOr[6])^2 +
                   (d[7] - fOr[7])^2 + (d[8] - fOr[8])^2 + (d[9] - fOr[9])^2 +
                   (d[10] - fOr[10])^2)
lend_fPr <- sqrt((d[1] - fPr[1])^2 + (d[2] - fPr[2])^2 + (d[3] - fPr[3])^2 +
                   (d[4] - fPr[4])^2 + (d[5] - fPr[5])^2 + (d[6] - fPr[6])^2 +
                   (d[7] - fPr[7])^2 + (d[8] - fPr[8])^2 + (d[9] - fPr[9])^2 +
                   (d[10] - fPr[10])^2)


#_________________________________________________________________________________
#change to 4 dimensional xfoss vector
lend_fBs4 <- sqrt((d[2] - fBs[2])^2 + (d[5] - fBs[5])^2 + (d[8] - fBs[8])^2 +
                    (d[10] - fBs[10])^2)
lend_fOr4 <- sqrt((d[2] - fOr[2])^2 + (d[5] - fOr[5])^2 + (d[8] - fOr[8])^2 +
                    (d[10] - fOr[10])^2)
lend_fPr4 <- sqrt((d[2] - fPr[2])^2 + (d[5] - fPr[5])^2 + (d[8] - fPr[8])^2 +
                    (d[10] - fPr[10])^2)


#_________________________________________________________________________________
#change to 3 dimensional vector
lend_fBs3 <- sqrt((d[8] - fBs[8])^2 + (d[9] - fBs[9])^2 + (d[10] - fBs[10])^2)
lend_fOr3 <- sqrt((d[8] - fOr[8])^2 + (d[9] - fOr[9])^2 + (d[10] - fOr[10])^2)
lend_fPr3 <- sqrt((d[8] - fPr[8])^2 + (d[9] - fPr[9])^2 + (d[10] - fPr[10])^2)


#_________________________________________________________________________________
#change to 3 dimensional inverse vector
lend_fBs3i <- sqrt((d[1] - fBs[1])^2 + (d[3] - fBs[3])^2 + (d[9] - fBs[9])^2)
lend_fOr3i <- sqrt((d[1] - fOr[1])^2 + (d[3] - fOr[3])^2 + (d[9] - fOr[9])^2)
lend_fPr3i <- sqrt((d[1] - fPr[1])^2 + (d[3] - fPr[3])^2 + (d[9] - fPr[9])^2)


#_________________________________________________________________________________
#change to 2 dimensional vector
lend_fBs2 <- sqrt((d[9] - fBs[9])^2 + (d[10] - fBs[10])^2)
lend_fOr2 <- sqrt((d[9] - fOr[9])^2 + (d[10] - fOr[10])^2)
lend_fPr2 <- sqrt((d[9] - fPr[9])^2 + (d[10] - fPr[10])^2)
