# NHS Patient Review Text Analysis

## Academic Project

This project was completed as part of an academic quantitative text analysis course. The objective was to apply natural language processing (NLP), statistical modeling, and machine learning techniques to analyze healthcare patient reviews.

Using a dataset of NHS patient reviews, this project investigates whether numerical star ratings accurately represent patient sentiment and explores how text-based methods can extract additional insights from written feedback.

## Research Question

Do patient star ratings accurately capture satisfaction expressed in written healthcare reviews, and can quantitative text analysis methods provide additional information about patient experiences?

## Dataset

The dataset contains 2,000 reviews of NHS doctors' surgeries across the United Kingdom.

Variables include:

- Patient review text
- Review title
- Star rating (1–5)
- Positive/negative review classification
- Review date
- Healthcare provider response status

*Note: The original dataset is not included due to data distribution restrictions.*

## Methods

This project applies four quantitative text analysis approaches:

### 1. Sentiment Analysis

- Cleaned and preprocessed patient review text
- Created document-feature matrices (DFMs)
- Applied the LSD2015 sentiment dictionary
- Calculated sentiment scores
- Compared text-based sentiment with star ratings

### 2. Word Embeddings

- Identified frequently occurring terms in patient reviews
- Created a review-specific dictionary
- Applied GloVe word embeddings for dictionary expansion
- Evaluated whether additional terms would significantly impact sentiment analysis

### 3. Naive Bayes Classification

- Built machine learning models to classify reviews as positive or negative
- Compared different text preprocessing strategies
- Evaluated model performance using:
  - Sensitivity
  - Specificity
  - Accuracy
  - Balanced accuracy

### 4. Text Scaling

- Applied Wordfish unsupervised text scaling
- Applied Wordscore supervised text scaling
- Compared document-level sentiment dimensions between methods

## Tools and Technologies

- R
- Quanteda
- tidyverse
- Natural Language Processing (NLP)
- Machine Learning
- Text Mining
- Statistical Analysis
- Data Visualization

## Repository Structure
