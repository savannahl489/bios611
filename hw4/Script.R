######################################
# File Setup
######################################

# Libraries Needed
library(readr)
library(tidyverse)

#######################################
# Task 1: Build the Shape Table
#######################################

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