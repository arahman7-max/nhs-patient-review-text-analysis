# --------------------------------------------------
# NHS Patient Review Text Analysis
# Part 3: Naive Bayes Classification
#
# Author: Adel Rahman
#
# Purpose:
# Build Naive Bayes classification models to predict
# positive and negative NHS patient reviews.
#
# Methods:
# - Compare different preprocessing strategies
# - Train/test split
# - Naive Bayes classification
# - Model evaluation
# --------------------------------------------------


# --------------------------------------------------
# Libraries
# --------------------------------------------------

library(tidyverse)
library(quanteda)
library(quanteda.textmodels)
library(caret)



# --------------------------------------------------
# 1. Dataset Overview
# --------------------------------------------------

glimpse(nhs_reviews)



# --------------------------------------------------
# 2. Set Random Seed
# --------------------------------------------------

set.seed(2040)



# --------------------------------------------------
# 3. Create Stopword-Removed DFM
# --------------------------------------------------

# Remove:
# - punctuation
# - numbers
# - symbols
# - stopwords

nhsr_stop <- nhs_corpus %>%
  tokens(
    remove_punct = TRUE,
    remove_numbers = TRUE,
    remove_symbols = TRUE
  ) %>%
  dfm() %>%
  dfm_remove(stopwords("en"))


print(nhsr_stop)



# --------------------------------------------------
# 4. Create Trimmed DFM
# --------------------------------------------------

# Keep original tokens but remove rare terms

nhsr_trim <- nhs_corpus %>%
  tokens() %>%
  dfm() %>%
  dfm_trim(min_termfreq = 7)


print(nhsr_trim)



# --------------------------------------------------
# 5. Compare DFM Dimensions
# --------------------------------------------------

str(nhsr_stop)

# Documents: 2000
# Features: 7616
# Non-zero entries: 70392


str(nhsr_trim)

# Documents: 2000
# Features: 1694
# Non-zero entries: 110995



# --------------------------------------------------
# 6. Naive Bayes Model: Stopword Removed DFM
# --------------------------------------------------

# Create training/testing split

nhsr_stop$train <- sample(
  x = c(TRUE, FALSE),
  size = nrow(nhsr_stop),
  replace = TRUE,
  prob = c(.75, .25)
)


nhsr_stop_dfm_train <- dfm_subset(
  nhsr_stop,
  train
)


nhsr_stop_dfm_test <- dfm_subset(
  nhsr_stop,
  !train
)



# Train Naive Bayes model

nb_train <- textmodel_nb(
  x = nhsr_stop_dfm_train,
  y = nhsr_stop_dfm_train$review_positive,
  prior = "docfreq"
)



# Most important words by class

head(
  sort(coef(nb_train)[,"Positive"], decreasing = TRUE),
  5
)


head(
  sort(coef(nb_train)[,"Negative"], decreasing = TRUE),
  5
)



# --------------------------------------------------
# 7. Naive Bayes Model: Trimmed DFM
# --------------------------------------------------


nhsr_trim$train <- sample(
  x = c(TRUE, FALSE),
  size = nrow(nhsr_trim),
  replace = TRUE,
  prob = c(.75, .25)
)


nhsr_trim_dfm_train <- dfm_subset(
  nhsr_trim,
  train
)


nhsr_trim_dfm_test <- dfm_subset(
  nhsr_trim,
  !train
)



# Train trimmed Naive Bayes model

nb_train_trim <- textmodel_nb(
  x = nhsr_trim_dfm_train,
  y = nhsr_trim_dfm_train$review_positive,
  prior = "docfreq"
)



head(
  sort(coef(nb_train_trim)[,"Positive"], decreasing = TRUE),
  5
)


head(
  sort(coef(nb_train_trim)[,"Negative"], decreasing = TRUE),
  5
)



# --------------------------------------------------
# 8. Evaluate Stopword-Removed Model
# --------------------------------------------------


# Training predictions

nhsr_stop_dfm_train$predicted_classification_nb <- predict(
  nb_train,
  type = "class"
)


confusion_train <- table(
  predicted_classification =
    nhsr_stop_dfm_train$predicted_classification_nb,
  true_classification =
    nhsr_stop_dfm_train$review_positive
)


confusion_train


confusion_train_statistics <- confusionMatrix(
  confusion_train,
  positive = "Positive"
)


confusion_train_statistics



# Testing predictions

nhsr_stop_dfm_test$predicted_classification_nb <- predict(
  nb_train,
  newdata = nhsr_stop_dfm_test,
  type = "class"
)


confusion_test <- table(
  predicted_classification =
    nhsr_stop_dfm_test$predicted_classification_nb,
  true_classification =
    nhsr_stop_dfm_test$review_positive
)


confusion_test


confusion_test_statistics <- confusionMatrix(
  confusion_test,
  positive = "Positive"
)


confusion_test_statistics



# --------------------------------------------------
# 9. Evaluate Trimmed Model
# --------------------------------------------------


# Training predictions

nhsr_trim_dfm_train$predicted_classification_nb <- predict(
  nb_train_trim,
  type = "class"
)


confusion_trim_train <- table(
  predicted_classification =
    nhsr_trim_dfm_train$predicted_classification_nb,
  true_classification =
    nhsr_trim_dfm_train$review_positive
)


confusion_trim_train_statistics <- confusionMatrix(
  confusion_trim_train,
  positive = "Positive"
)


confusion_trim_train_statistics



# Testing predictions

nhsr_trim_dfm_test$predicted_classification_nb <- predict(
  nb_train_trim,
  newdata = nhsr_trim_dfm_test,
  type = "class"
)


confusion_trim_test <- table(
  predicted_classification =
    nhsr_trim_dfm_test$predicted_classification_nb,
  true_classification =
    nhsr_trim_dfm_test$review_positive
)


confusion_trim_test_statistics <- confusionMatrix(
  confusion_trim_test,
  positive = "Positive"
)


confusion_trim_test_statistics



# --------------------------------------------------
# Conclusion
# --------------------------------------------------

# The stopword-removed DFM produced stronger classification
# performance compared with the trimmed DFM.
#
# This suggests preprocessing choices influence machine
# learning performance in text classification tasks.
#
# Removing irrelevant terms and focusing on meaningful
# features improved the model's ability to distinguish
# positive and negative reviews.


