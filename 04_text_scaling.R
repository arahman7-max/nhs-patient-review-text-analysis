nhs_corpus <- corpus(nhs_reviews, text_field = "review_text")

#task 1
nhsr_dfmII <- nhs_corpus %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>%
  dfm() %>%
  dfm_trim(min_docfreq = 8) %>%
  dfm_remove(stopwords("en"))


#task 2
nhsr_txw <- textmodel_wordfish(nhsr_dfmII, dir = c(4, 3))

#task 3
theta_nhsr<- nhsr_txw$theta 
str(theta_nhsr)

#task 4
nhsr_ws <- textmodel_wordscores(nhsr_dfmII, y = nhsr_dfmII$star_rating, smooth = 1)
pred_nhsr_ws <- predict(nhsr_ws, se.fit = TRUE, newdata = nhsr_dfmII)

#task 5
str(pred_nhsr_ws)

#task 6-7
pred_nhsr_ws <- predict(nhsr_ws, se.fit = TRUE, newdata = nhsr_dfmII)
theta_ws <- pred_nhsr_ws$fit
theta_cor <- data.frame(theta_nhsr = theta_nhsr, theta_ws = theta_ws)
wswf_correlation <- cor(theta_cor$theta_nhsr, theta_cor$theta_ws)
wswf_correlation

ggplot(theta_cor, aes(x = theta_nhsr, y = theta_ws)) +
  geom_point() +
  labs(title = "Comparison of Wordfish and Wordscore Theta",
       x = "Wordfish Theta", y = "Wordscore Theta") +
  theme_minimal()

theta_ws_rescaled <- scales::rescale(theta_ws, to = range(theta_nhsr))

cor(theta_nhsr, theta_ws_rescaled)

ggplot(theta_cor, aes(x = theta_nhsr, y = theta_ws_rescaled)) +
  geom_point() +
  labs(title = "Comparison of Wordfish and Wordscore Theta",
       x = "Wordfish Theta", y = "Wordscore Theta") +
  theme_minimal()

#8.Graph is about a 45 degree angle, diagonal line.
