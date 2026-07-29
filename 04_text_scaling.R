# --------------------------------------------------
# NHS Patient Review Text Analysis
# Part 4: Text Scaling
#
# Author: Adel Rahman
#
# Purpose:
# Apply supervised and unsupervised text scaling methods
# to estimate latent dimensions of patient reviews.
#
# Methods:
# - Wordfish (unsupervised scaling)
# - Wordscore (supervised scaling)
# - Correlation comparison
# - Visualization of document-level scores
# --------------------------------------------------


# --------------------------------------------------
# Libraries
# --------------------------------------------------

library(tidyverse)
library(quanteda)
library(quanteda.textmodels)
library(scales)



# --------------------------------------------------
# 1. Create Clean Document-Feature Matrix
# --------------------------------------------------

# Convert reviews into a corpus

nhs_corpus <- corpus(
  nhs_reviews,
  text_field = "review_text"
)


# Preprocess text:
# - Remove punctuation
# - Remove numbers
# - Remove symbols
# - Remove stopwords
# - Remove rare terms

nhsr_dfm <- nhs_corpus %>%
  tokens(
    remove_punct = TRUE,
    remove_numbers = TRUE,
    remove_symbols = TRUE
  ) %>%
  dfm() %>%
  dfm_trim(
    min_docfreq = 8
  ) %>%
  dfm_remove(
    stopwords("en")
  )



# --------------------------------------------------
# 2. Wordfish Model (Unsupervised Scaling)
# --------------------------------------------------

# Wordfish estimates latent positions of documents
# without using existing labels.

nhsr_wordfish <- textmodel_wordfish(
  nhsr_dfm,
  dir = c(4, 3)
)



# Store document-level theta estimates

theta_wordfish <- nhsr_wordfish$theta


str(theta_wordfish)



# --------------------------------------------------
# 3. Wordscore Model (Supervised Scaling)
# --------------------------------------------------

# Wordscore uses star ratings as reference values
# to estimate document positions.

nhsr_wordscore <- textmodel_wordscores(
  nhsr_dfm,
  y = nhsr_dfm$star_rating,
  smooth = 1
)



# Generate predicted document scores

pred_wordscore <- predict(
  nhsr_wordscore,
  se.fit = TRUE,
  newdata = nhsr_dfm
)


str(pred_wordscore)



# Store Wordscore theta values

theta_wordscore <- pred_wordscore$fit



# --------------------------------------------------
# 4. Compare Wordfish and Wordscore
# --------------------------------------------------

theta_comparison <- data.frame(
  wordfish_theta = theta_wordfish,
  wordscore_theta = theta_wordscore
)



# Calculate correlation

theta_correlation <- cor(
  theta_comparison$wordfish_theta,
  theta_comparison$wordscore_theta
)


theta_correlation



# --------------------------------------------------
# 5. Visualize Model Agreement
# --------------------------------------------------

ggplot(
  theta_comparison,
  aes(
    x = wordfish_theta,
    y = wordscore_theta
  )
) +
  geom_point() +
  labs(
    title = "Comparison of Wordfish and Wordscore Theta",
    x = "Wordfish Theta",
    y = "Wordscore Theta"
  ) +
  theme_minimal()



# --------------------------------------------------
# 6. Rescale Wordscore Results
# --------------------------------------------------

# Wordfish and Wordscore may have different scales,
# so rescale Wordscore estimates to match Wordfish.

theta_wordscore_rescaled <- scales::rescale(
  theta_wordscore,
  to = range(theta_wordfish)
)



# Calculate correlation after rescaling

rescaled_correlation <- cor(
  theta_wordfish,
  theta_wordscore_rescaled
)


rescaled_correlation



# Plot rescaled comparison

theta_rescaled_comparison <- data.frame(
  wordfish_theta = theta_wordfish,
  wordscore_theta = theta_wordscore_rescaled
)



ggplot(
  theta_rescaled_comparison,
  aes(
    x = wordfish_theta,
    y = wordscore_theta
  )
) +
  geom_point() +
  labs(
    title = "Rescaled Comparison of Wordfish and Wordscore Theta",
    x = "Wordfish Theta",
    y = "Rescaled Wordscore Theta"
  ) +
  theme_minimal()



# --------------------------------------------------
# Conclusion
# --------------------------------------------------

# Wordfish and Wordscore produce similar document-level
# rankings when the correlation is high and points follow
# an approximate diagonal pattern.
#
# This suggests that supervised and unsupervised text
# scaling methods capture similar underlying dimensions
# of patient review sentiment.
  theme_minimal()

#8.Graph is about a 45 degree angle, diagonal line.
