#View the data and variables
glimpse(nhs_reviews)

#task 1
set.seed(2040)


#task 2
# Rename the DFM from Part 1 as nhsr_stop
nhsr_stop <- nhs_corpus %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>%
  dfm() %>%
  dfm_remove(stopwords("en"))
print(nhsr_stop)

#task 3
nhsr_trim <- nhs_corpus %>%
  tokens() %>%
  dfm() %>%
  dfm_trim(min_termfreq = 7)
print(nhsr_trim)

#task 4
str(nhsr_stop)

#docs 2000
#features 7616
#x 70392

str(nhsr_trim)

#docs 2000
#features 1694
#x 110995

#task 5 (stop)
nhsr_stop$train <- sample(x = c(TRUE, FALSE), #Assign to train
                            #variable (1/10 or T/F)
                            size = nrow(nhsr_stop), #No. of items 
                            #choose
                            replace = TRUE, #Sampling with replacement
                            prob = c(.75, .25)) #% data assigned to
#training and testing sets

# Subset to training set observations

nhsr_stop_dfm_train <- dfm_subset(nhsr_stop, train)

#Subset to test set observations

nhsr_stop_dfm_test <- dfm_subset(nhsr_stop, !train)

#Naive Bayes classifier
nb_train <- textmodel_nb(x = nhsr_stop_dfm_train,
                         y = nhsr_stop_dfm_train$review_positive,
                         prior = "docfreq")
#Retrieve the conditional word probabilities
head(sort(coef(nb_train)[,"Positive"], decreasing = T), 5)

head(sort(coef(nb_train)[,"Negative"], decreasing = T), 5)

#task 5 (for trim instead of stop)
nhsr_trim$train <- sample(x = c(TRUE, FALSE), #Assign to train
                          #variable (1/10 or T/F)
                          size = nrow(nhsr_trim), #No. of items 
                          #choose
                          replace = TRUE, #Sampling with replacement
                          prob = c(.75, .25)) #% data assigned to
#training and testing sets

# Subset to training set observations

nhsr_trim_dfm_train <- dfm_subset(nhsr_trim, train)

#Subset to test set observations

nhsr_trim_dfm_test <- dfm_subset(nhsr_trim, !train)

#Naive Bayes classifier
nb_train_trim <- textmodel_nb(x = nhsr_trim_dfm_train,
                         y = nhsr_trim_dfm_train$review_positive,
                         prior = "docfreq")
#Retrieve the conditional word probabilities
head(sort(coef(nb_train_trim)[,"Positive"], decreasing = T), 5)

head(sort(coef(nb_train_trim)[,"Negative"], decreasing = T), 5)

#task 6

nhsr_stop_dfm_train$positive_nb_probability <- predict(nb_train, type = "probability")[,2]

nhsr_stop_dfm_train$predicted_classification_nb <- predict(nb_train, type = "class")

confusion_train <- table(predicted_classification = nhsr_stop_dfm_train$
                           predicted_classification_nb, 
                         true_classification = nhsr_stop_dfm_train$review_positive)
confusion_train

confusion_train_statistics <- confusionMatrix(confusion_train, 
                                              positive = "Positive")
confusion_train_statistics

nhsr_stop_dfm_test$predicted_classification_nb <- predict(nb_train, 
                                                           newdata = nhsr_stop_dfm_test, 
                                                           type = "class")

confusion_test <- table(predicted_classification = nhsr_stop_dfm_test$
                          predicted_classification_nb, 
                        true_classification = nhsr_stop_dfm_test$
                          review_positive)
confusion_test
confusion_test_statistics <- confusionMatrix(confusion_test, 
                                             positive = "Positive")
confusion_test_statistics

#task 6 Pt. II

nhsr_trim_dfm_train$positive_nb_probability <- predict(nb_trim_train, type = "probability")[,2]

nhsr_trim_dfm_train$predicted_classification_nb <- predict(nb_trim_train, type = "class")

confusion_trim_train <- table(predicted_classification = nhsr_trim_dfm_train$
                                predicted_classification_nb, 
                              true_classification = nhsr_trim_dfm_train$review_positive)
confusion_trim_train
confusion_trim_train_statistics <- confusionMatrix(confusion_trim_train, 
                                                   positive = "Positive")
confusion_trim_train_statistics

nhsr_trim_dfm_test$predicted_classification_nb <- predict(nb_trim_train, 
                                                           newdata = nhsr_trim_dfm_test,
                                                           type = "class")

confusion_trim_test <- table(predicted_classification = nhsr_trim_dfm_test$
                               predicted_classification_nb, 
                             true_classification = nhsr_trim_dfm_test$
                               review_positive)
confusion_trim_test
confusion_trim_test_statistics <- confusionMatrix(confusion_trim_test, 
                                                  positive = "Positive")
confusion_trim_test_statistics

#7 The stop dfm has a higher accuracy compared to trim.
#The stop dfm was tokenized and removed stop words. Trim did not do
#any of that. The supervisor should be concerned because the 
#pre-processed stop dfm has an overall higher accuracy.


