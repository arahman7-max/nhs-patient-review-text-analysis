# --------------------------------------------------
# NHS Patient Review Text Analysis
# Part 1: Sentiment Analysis
#
# Author: Adel Rahman
#
# Purpose:
# Analyze NHS patient reviews using dictionary-based
# sentiment analysis and compare text sentiment with
# numerical star ratings.
#
# Methods:
# - Text preprocessing
# - Document-feature matrix creation
# - LSD2015 sentiment dictionary
# - Sentiment score calculation
# --------------------------------------------------


# --------------------------------------------------
# Libraries
# --------------------------------------------------

library(tidyverse)
library(quanteda)
library(quanteda.textstats)


# --------------------------------------------------
# 1. Dataset Overview
# --------------------------------------------------

# Calculate average star rating
mean(nhs_reviews$star_rating, na.rm = TRUE)

# Count positive and negative reviews
count <- nhs_reviews %>% 
  count(review_positive)

count


# --------------------------------------------------
# 2. Text Preprocessing
# --------------------------------------------------

# Convert review text into a quanteda corpus
nhs_rev <- corpus(
  nhs_reviews,
  text_field = "review_text"
)


# Tokenize text and remove:
# - punctuation
# - numbers
# - symbols

nhs_toks <- tokens(
  nhs_rev,
  remove_punct = TRUE,
  remove_numbers = TRUE,
  remove_symbols = TRUE
)


# Remove English stopwords

nhs_toks <- tokens_remove(
  nhs_toks,
  stopwords("en")
)


# Convert tokens into document-feature matrix

nhs_dfm <- dfm(nhs_toks)

dim(nhs_dfm)


# --------------------------------------------------
# 3. Dictionary-Based Sentiment Analysis
# --------------------------------------------------

# Load LSD2015 sentiment dictionary

nhs_sentiment <- data_dictionary_LSD2015


# Apply sentiment dictionary

nhs_senti_dfm <- dfm_lookup(
  nhs_dfm,
  dictionary = nhs_sentiment
)


# Convert sentiment dfm into dataframe

nhs_sscores <- quanteda::convert(
  nhs_senti_dfm,
  to = "data.frame"
)


# Calculate sentiment score:
# Positive words - Negative words

nhs_sscores <- nhs_sscores %>%
  mutate(
    senti_score = positive - negative
  )


print(nhs_sscores)


# Add original review classification

nhs_sscores$review_positive <- 
  nhs_reviews$review_positive



# --------------------------------------------------
# 4. Compare Sentiment by Review Classification
# --------------------------------------------------

avg_senti_by_review_positive <- nhs_sscores %>%
  group_by(review_positive) %>%
  summarise(
    avg_sent = mean(senti_score)
  )


print(avg_senti_by_review_positive)



# --------------------------------------------------
# 5. Weighted Average Sentiment
# --------------------------------------------------

# Calculate weighted sentiment score
# based on positive and negative review proportions

negative_weight <- 754 / (754 + 1232)

positive_weight <- 1232 / (754 + 1232)


weighted_sentiment <- 
  (negative_weight * -1.29) +
  (positive_weight * 3.81)


weighted_sentiment


# Interpretation:
#
# The weighted sentiment score can be compared
# against the average star rating to determine
# whether numerical ratings overestimate or
# underestimate patient satisfaction.



# --------------------------------------------------
# 6. Sentiment Range
# --------------------------------------------------

range_senti <- range(
  nhs_sscores$senti_score,
  na.rm = TRUE
)

print(range_senti)

summary(range_senti)



# --------------------------------------------------
# Conclusion
# --------------------------------------------------

# Text-based sentiment suggests that star ratings
# may overestimate patient satisfaction because
# some reviews with moderate ratings contain
# language associated with negative sentiment.
#
# A possible improvement would be expanding the
# rating system or combining numerical ratings
# with text-based sentiment analysis.









