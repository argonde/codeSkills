Tweet Sentiment Analysis
=====================
### Motivation
---

Using R's 'twitteR' package to gather tweets, the 'tm' package to prepare the corpus of those messages, and the dot product of their sentiment analysis vectors, this R file attempts to establish a measurement of similarity in discourse, and a threshold to diconnected discourse.  

Given that the dot product is calculated on data streams, synchronous samples of tweets obtained at intervals, this tool may find use as a SoMe alert. It marks periods of time when the sentiment of SoMe business discourse can be labeled as disconnected from that of its followers.  

The use of the R package 'wordcloud' should get an insight into the topics on which such disconnect is happening.

---

### Fetched 1000 xFoss followers and tested the first available 100.

  This might be close to a random selection, since the followers are not listed in alphabetical, or other, order.

  The result from about 73 followers was a cosine similarity of ~0.975  (i.e. 0.9753806).

  The total amount of followers is about 9350, a sample of 1% = ~93 followers.

  However, on my machine R can only work with a matrix of up to 1Gb (i.e. 120 tweets from up to 75 users).

1. From the first 250 Twitter followers →  102 were available (which is >1%). Reasons were:
    - Non-existing (ID formed by non-UTF-8 characters exclusively).

    - ID was UTF-8 non-compliant.

    - Privacy settings : The command will return only *__authorized tweets__* **.

    ** Authorized tweets are public tweets, as well as those protected tweets, that are available to the user after authenticating via registerTwitterOAuth. Most of these accounts affected by privacy settings, have name and surname, meaning that they may be private accounts.

2. Sampled the latest 1000 tweets published by xFoss, and the latest 120 tweets published by each selected follower (max. 75 users).
    - Many of the first 102 available follower accounts contain few twits:
      - Sporadic conversations: “thanks for following us”.

      - *__Repetitive tweets__* ** without connexion to xFoss.

        ** Many open profiles might be business, or business oriented, and therefore a % might be spam, promotion or irrelevant. In order to filter these, set the minimum twitter history to 15 tweets.
    - only about 50 follower accounts out of 102 (i.e. out of 250) were viable.

    - from 1000 followers there are potentially 3 batches of 75 available followers.

3. Vectors for the comparison are elaborated from:
    - latest 1000 xFoss tweets.

    - latest 120 tweets from each account of a set of 75 active followers (>15 tweets).

4. These batches (of 75 users) can correspond to segments of xFoss followers. These were selected by the name of the twitter account:
    - Business (name contains business oriented words: engineering, group, industry ...)

    - Private (name and surname)

    - Other (none of the above)

5. In relation to the sentiment analysis, I had a response to 10 variables to form the vectors:

    anger | anticipation | disgust | fear | joy | sadness | surprise | trust | negative | positive

---
### Results of the cosine similarity calculation on the segments are the following:

  - Business followers = 0.9806806

  - Other followers= 0.9768141

  - Private followers= 0.9440844

Results have been normalised (avg), and will tend to show a large degree of similarity.
  - A tweet is a social message, after all. The central tendency of their attitude shifts slightly, for it is primarily/preferably geared toward gaining and keeping friends/followers.

  -  However, it results more nuanced, and balanced to negative dimensions, when broadcast by private users.

1. Looking at a bar chart of the different variables, there is a clear pattern on where does the business samples differ. These areas define the message that the company attempts to convey:

    positive  /  trust  /  anticipation  /  joy

2. In these areas the agreement between central tendency attitudes is at its highest, and  inverted.

3. However, if you look at the actual distance between plotted points, private followers fall furthest than the others 

    |                    | Vector        | Distance  |
    | ------------------ |:-------------:| ---------:|
    | Business followers | 0.9959517     | 0.3291633 |
    | Other followers    | 0.997689      | 0.3599494 |
    | Private followers  | 0.9993321     | 0.4103065 |

This means that in absolute terms the values of private followers are least related to xFoss, but in terms of the direction, their central tendency vectors are similar.

---
### Final Results


Other customised vectors were as well tried. The sentiment variables can be also classified into:

   Affective (ruled by emotion) | Behavioural (by experience) | Cognitive (by norms & beliefs)

  - Affective : 
    - positive  |  negative  |  joy  |  sadness

  - Behavioural:
    - trust  |  surprise  |  anticipation

  - Cognitive:
    - anger  |  disgust  |  fear

    3dimensional, main affective & behavioural variables →

    | [trust - negative - positive] | Vector   | Distance  |
    | ----------------------------- |:--------:| ---------:|
    | Business followers            | 0.9866916| 0.3148043 |
    | Other followers               | 0.9844948| 0.3592223 |
    | Private followers             | 0.958789 | 0.4474235 |

    (+0.1326192, ↑ 142.1275%)

    3dimensional, cognitive & affective, xFoss inverted →

    | [anger - disgust - negativeness] | Vector   | Distance  |
    | -------------------------------- |:--------:| ---------:|
    | Business followers               | 0.9978089| 0.1021419 |
    | Other followers                  | 0.9908663| 0.1264991 |
    | Private followers                | 0.9868126| 0.2725937 |

    (+0.1704518,  ↑ 266.8775%)

    2dimensional, main affective variables →

    | [negativeness - positiveness] | Vector   | Distance  |
    | ----------------------------- |:--------:| ---------:|
    | Business followers            | 0.9905387| 0.1976926 |
    | Other followers               | 0.9839952| 0.2629362 |
    | Private followers             | 0.9467314| 0.3829191 |
    
    (+0.1852265,   ↑ 193.6942)

   The maximum contrast between private followers and xFoss is achieved in these 2 dimensions.
    However the parameter distance (i.e. length of the vector between both xFoss and its followers location) is much larger in when negative variables are dominant, those probably avoided by xFoss in its communication.

  Possible values for setting an alarm could be a vector cosine similarity of	< 0.975  or	 < 0.95