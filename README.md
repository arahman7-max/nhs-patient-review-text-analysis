# NHS Healthcare Review Text Analysis

## Overview

This repository contains an academic NLP and quantitative text analysis project analyzing patient reviews of NHS healthcare providers in the United Kingdom.

The goal of this project was to investigate whether traditional star ratings accurately represented patient sentiment and to apply multiple text analytics methods to extract insights from unstructured healthcare review data.

This project was completed as part of coursework in quantitative text analysis and demonstrates the application of statistical programming, natural language processing (NLP), machine learning, and statistical modeling techniques using R.

---

## Dataset

The dataset contains 2,000 patient reviews of NHS doctors' surgeries with the following information:

- Review text
- Star rating (1–5)
- Positive/negative review classification
- Review date
- Whether the healthcare provider responded

The original dataset is not included due to data distribution restrictions.

---

## Project Methods

### 1. Sentiment Analysis

The first analysis examined whether patient star ratings aligned with the sentiment expressed in written reviews.

Methods used:

- Text preprocessing
- Tokenization
- Document-feature matrix creation
- LSD2015 sentiment dictionary
- Sentiment score calculation

Key question:

> Do numerical ratings accurately reflect the sentiment expressed in patient reviews?

---

### 2. Word Embeddings

The second analysis explored whether word embeddings could expand a sentiment dictionary by identifying semantically similar words.

Methods used:

- Frequency-based dictionary creation
- GloVe word embeddings
- Cosine similarity
- Dictionary expansion evaluation

Key question:

> Would expanding the sentiment dictionary improve sentiment analysis results?

---

### 3. Naive Bayes Classification

The third analysis applied supervised machine learning to predict whether reviews were positive or negative.

Methods used:

- Document-feature matrices
- Training/testing split
- Naive Bayes classification
- Confusion matrices
- Accuracy, sensitivity, and specificity evaluation

Two preprocessing strategies were compared:

- Stopword removal and text cleaning
- Term-frequency trimming

Key question:

> How does text preprocessing affect machine learning classification performance?

---

### 4. Text Scaling

The final analysis applied statistical NLP techniques to estimate latent dimensions within patient reviews.

Methods used:

- Wordfish (unsupervised text scaling)
- Wordscore (supervised text scaling)
- Correlation analysis
- Visualization of document-level scores

Key question:

> Do supervised and unsupervised text scaling approaches identify similar patterns in healthcare reviews?

---

## Technologies Used

- R
- Quanteda
- Quantitative Text Analysis
- Natural Language Processing (NLP)
- Machine Learning
- Statistical Modeling
- Data Visualization

---

## Repository Structure

- 01_sentiment_analysis.R
- 02_word_embeddings.R
- 03_naive_bayes_classification.R
- 04_text_scaling.R
- README.md

---

## Skills Demonstrated

- Cleaning and preprocessing unstructured text data
- Creating analytical features from text
- Applying NLP methods
- Building and evaluating classification models
- Comparing modeling approaches
- Interpreting quantitative results
- Communicating analytical findings
