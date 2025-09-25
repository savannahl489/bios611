############################################
# File Setup
############################################

# Libraries Needed
library(readr)
library(tidyverse)
library(ggplot2)
library(stopwords)
library(RColorBrewer)
library(wordcloud)

############################################
# Task 1: Build the Shape Table
############################################

# Reading in the data:
raw_df<- read_csv("work/nuforc_sightings.csv")
state_map <- read_csv("work/states.csv")


# Filtering the data:
USA_df <- raw_df %>% mutate(state = tolower(state), 
                            country = tolower(country),
                            shape = tolower(shape)) %>% 
  filter(state %in% state_map$state | country == 'usa') %>% 
  mutate(state = recode(state,"ohio" = "oh", 
                        "new york" = "ny", "montana" = "mt",
                        "west virginia" = "wv", "wisconsin" = "wi")) %>% 
  filter(state %in% state_map$state | state == "-" |
           state == "0" | state == "dc")

# Standardizing the shape column:
stand_shape <- USA_df %>% 
  mutate(shape = ifelse(is.na(shape) | shape == "", "unknown",shape))


# Creating the pivot table:
shape_by_state <- stand_shape %>% group_by(state, shape) %>%
  summarise(count = n(), .groups = "drop") 

shape_state_pivot <- shape_by_state %>% pivot_wider(
  names_from = shape, values_from = count, values_fill = 0)

# INSERT COMMENT : There are 22 shapes in total excluding unknown and other. 
# California/ CA saw the most circular shapes.

################################################
# TASK 2: PCA on the Shape Table
################################################

# Row-normalizing the table:
shape_state_norm <- shape_state_pivot %>% rowwise() %>%
  mutate(total = sum(c_across(-state))) %>%   
  mutate(across(-c(state, total), ~ .x / total)) %>%
  select(-total) %>%
  ungroup()

# Performing PCA:
pca_shape <- prcomp(shape_state_norm[, -1], center = TRUE, scale. = TRUE)

# Proportion of variance explained & scree plot:
pve_shape <- (pca_shape$sdev)^2 / sum(pca_shape$sdev^2)
plot(pve_shape, type = "b", xlab = "Principal Component", 
     ylab = "Proportion of Variance Explained", main = "Scree Plot")
# INSERT COMMENT: It does seem that the variety of UFO sightings can be boiled
# down to a few key patterns. Based on the scree plot, the proportion of variance
# explained by the first few principle components are enough to cover the majority
# of variance in the data.

# Scatterplot:
pca_shape_df <- as.data.frame(pca_shape$x)

ggplot(pca_shape_df, aes(x = PC1, y = PC2)) +
  geom_point(color = "steelblue", size = 3) +
  labs(title = "Shape PC1 vs PC2",
       x = "Principal Component 1",
       y = "Principal Component 2") +
  theme_minimal()
# INSERT COMMENT: Based on the scatterplot, the majority of states seem to be in
# one cluster. There are two states that exhibit outlier tendencies.

# PCA rotation:
rotation_tbl <- as.data.frame(pca_shape$rotation) %>%
  round(3) %>% .[,c(1,2)] %>% 
  rownames_to_column(var = "Variable")
print(rotation_tbl)
# INSERT COMMENT: It seems as though the shapes "light", "sphere", and "disk"
# affect PC1 the most. For PC2, the shapes "cylinder", "cube", and "unknown"
# contributed the most.

################################################
# TASK 3: Clean and Tokenize the Summaries
################################################

#To clean up the summaries:
Encoding(USA_df$summary) <- "UTF-8"
clean_summary <- USA_df %>% 
  mutate(summary = tolower(summary)) %>%
  mutate(summary = iconv(summary, from = "UTF-8", to = "ASCII", sub = "")) %>%
  mutate(summary = gsub("\\s+", " ", trimws(summary)))

# Making an array of words and removing punctuation:
word_array <- clean_summary %>% mutate(words = strsplit(summary, split = " "))
all_words <- unlist(word_array$words) %>% gsub("[[:punct:]]", "", .)

#Frequency of each word:
freq_word <- table(all_words) %>% as.data.frame(.)
colnames(freq_word) <- c("word", "frequency")
freq_word <- freq_word[order(-freq_word$frequency), ]

# Table and word cloud:
print(freq_word) #INSERT COMMENT: I chose to visualize this via a table because
#of the number of unique words. A histogram was not a helpful visualization/ feasible.

wordcloud(words = freq_word$word,
          freq = freq_word$frequency,
          min.freq = 1,
          random.order = FALSE,
          colors = brewer.pal(8, "Dark2"))
# INSERT COMMENT: The most frequent words are generally generic English words or
# generic words used to describe UFOs.

# Removing stopwords from all_words:
all_words_clean <- all_words[!all_words %in% stopwords('en')]

clean_word <- table(all_words_clean) %>% as.data.frame(.)
colnames(clean_word) <- c("word", "frequency")
clean_word <- clean_word[order(-clean_word$frequency), ]

# Histogram of cleaned words:
top_20 <- head(clean_word, 20)
ggplot(top_20, aes(x = reorder(word, frequency), y = frequency)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # Flips to horizontal bars
  labs(title = "Top 20 Most Frequent Words",
       x = "Words",
       y = "Frequency") +
  theme_minimal()
# INSERT COMMENT: From the top frequent words after cleaning, we find the words
# "light"/"lights"/"bright", "sky", and "moving" as some of the top characterizations of
# UFO sightings