############################################
# File Setup
############################################

# Libraries Needed
library(readr)
library(tidyverse)
library(ggplot2)
library(stopwords)


############################################
# Task 1: Build the Shape Table
############################################

# Reading in the data:
raw_df<- read.csv("work/nuforc_sightings.csv")
state_map <- read.csv("work/states.csv")


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

# Performing PCA: DO I NEED TO LOG-RATIO THE DATA?
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