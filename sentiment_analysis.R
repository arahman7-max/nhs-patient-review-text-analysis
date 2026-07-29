mean(nhs_reviews$star_rating, na.rm =TRUE)
count <- nhs_reviews %>% count(review_positive)
count


#Open mfts_texts data and change to corpus
nhs_rev <- corpus(nhs_reviews, text_field = "review_text")


#Toke

nhs_toks <- tokens(nhs_rev, remove_punct = TRUE, remove_numbers =  TRUE, remove_symbols = TRUE)

#Remove stops

nhs_toks <- tokens_remove(nhs_toks, stopwords("en"))

#Convert to dfm
nhs_dfm <- dfm(nhs_toks)


dim(nhs_dfm)

#ii) Label the dictionary
nhs_sentiment <- data_dictionary_LSD2015

#iii) Apply the dictionary to create a dfm of sentiments. NOTE: Remember that the 
#LSD2015 dictionary comes with polarity and valence assigned. We used a lot of code
#in class to construct our own dictionaries and add polarity and valence. Those steps
#are not relevant here. Please use only the code necessary for this step given the use of
#the LSD2015 dictionary.
nhs_senti_dfm <- dfm_lookup(nhs_dfm, dictionary = nhs_sentiment)

#iv) Convert the dfm of sentiments to a data frame.
nhs_sscores <- quanteda::convert(nhs_senti_dfm, to = "data.frame")

#Calculate senti score (polarity as :Pos vs Neg)
nhs_sscores <- nhs_sscores %>%
  mutate(senti_score = positive - negative)
print(nhs_sscores)


nhs_sscores$review_positive <- nhs_reviews$review_positive

avg_senti_by_review_positive <- nhs_sscores %>%
  group_by(review_positive) %>%
  summarise(avg_sent = mean (senti_score))
print(avg_senti_by_review_positive)

#3.

((754)/(754+1232))*(-1.29) = -0.4897583

((1232)/(754+1232))*(3.81) = 2.363505

(2.363505-0.4897583)/2 = 0.93

#4. Overestimating since people are giving 3 stars but their reviews reflect 
#an opinion closer to 1 star (with the actual language)


#5. Should expand star system to negative. So like -5 to 5 to account for more
#negative reviews

range_senti <- range(nhs_sscores$senti_score, na.rm = TRUE)
print(range_senti)
summary(range_senti)









