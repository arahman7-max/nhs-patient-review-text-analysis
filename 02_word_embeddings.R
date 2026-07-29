# --------------------------------------------------
# NHS Patient Review Text Analysis
# Part 2: Word Embeddings
#
# Author: Adel Rahman
#
# Purpose:
# Evaluate whether word embeddings can expand a
# sentiment dictionary created from NHS patient reviews.
#
# Methods:
# - Extract frequently occurring review terms
# - Create review-specific dictionary
# - Apply GloVe word embeddings
# - Evaluate potential dictionary expansion
# --------------------------------------------------


# --------------------------------------------------
# Libraries
# --------------------------------------------------

library(tidyverse)
library(quanteda)


# --------------------------------------------------
# 1. Create Top-50 Review Dictionary
# --------------------------------------------------

# Extract the 50 most frequent terms from the
# preprocessed NHS review document-feature matrix

top_words <- topfeatures(
  nhs_dfm,
  50
)


# Extract word names

words <- names(top_words)


# Convert words into dictionary format

top_words_list <- list(
  frequent_words = words
)


top_words_dict <- dictionary(top_words_list)

top_words_dict



# --------------------------------------------------
# 2. Expand Dictionary Using GloVe Embeddings
# --------------------------------------------------

# Check GloVe dimensions

dim(glove)


# Flatten dictionary into usable word list

nhsr_words <- unlist(
  top_words_dict,
  use.names = FALSE
)


# Select embeddings for review vocabulary

nhsr_embeddings <- glove[
  rownames(glove) %in% nhsr_words,
]


# Calculate average embedding vector

nhsr_embeddings_mean <- colMeans(
  nhsr_embeddings
)


# Calculate similarity between vocabulary
# and average review embedding

target_sim <- sim2(
  x = glove,
  y = matrix(nhsr_embeddings_mean, nrow = 1)
)



# --------------------------------------------------
# 3. Identify Similar Words
# --------------------------------------------------

threshold <- 0.75


high_sim_words <- rownames(glove)[
  target_sim > threshold
]


# Combine original and expanded dictionary terms

expanded_dictionary <- unique(
  c(nhsr_words, high_sim_words)
)


view(expanded_dictionary)



# --------------------------------------------------
# 4. Evaluate Dictionary Expansion
# --------------------------------------------------

# Identify the top 50 most similar words

top50 <- names(
  sort(
    target_sim[,1],
    decreasing = TRUE
  )
)[1:50]


table(
  top50 %in% top_words_dict
)


print(top50)



# --------------------------------------------------
# 5. Interpretation
# --------------------------------------------------

# Findings:
#
# The embedding expansion did not identify meaningful
# sentiment-related terms that would substantially
# change the original sentiment analysis.
#
# Some identified terms appear unrelated to patient
# sentiment, suggesting that dictionary expansion
# using these embeddings would provide limited value
# for this analysis.
#
# The original LSD2015 sentiment dictionary appears
# sufficient for measuring patient sentiment in this
# dataset.


print(high_sim_words)









