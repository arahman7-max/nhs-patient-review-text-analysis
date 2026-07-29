
top_words <- topfeatures(nhs_dfm, 50)
words <- names(top_words)
top_words_list <- list(frequent_words = words)
top_words_dict <- dictionary(top_words_list)
top_words_dict

#Data dimensions
dim(glove)

nhsr_words <- unlist(top_words_dict, use.names = FALSE)



nhsr_embeddings <- glove[rownames(glove) %in% nhsr_words,]

nhsr_embeddings_mean <-colMeans(nhsr_embeddings)

target_sim <- sim2(x = glove,
                   y = matrix(nhsr_embeddings_mean, nrow = 1))

threshold <- 0.75

high_sim_words <- rownames(glove)[target_sim > threshold]

expanded_dictionary <- unique(c(nhsr_words, high_sim_words))
view(expanded_dictionary)

#Top 50
top50 <- names(sort(target_sim[,1], decreasing = T))[1:50]


table(top50%in%top_words_dict)
print(top50)

#3. None of the new words were in the original dictionary.

#4. There is still punctuation since we did not define glove.

#5. 20 percent increase (10 more words)

#6. No, they would not alter to analysis in Part 1 since they do not reflect sentiments
#of reviews.

print(high_sim_words)


#7. Since the added words are just words of punctuation, there is 
#no need to expand the dictionary. The words in the top 50 are irrelevant to patients
#and do not reflect emotions.









