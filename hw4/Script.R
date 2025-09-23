######################################
# File Setup
######################################

# Libraries Needed
library(readr)
library(tidyverse)

#######################################
# Task 1: Build the Shape Table
#######################################

# Reading in the Data:
raw_df<- read.csv("work/nuforc_sightings.csv")

state_map <- tribble(
  ~state, ~name,
  "al", "Alabama",
  "ak", "Alaska",
  "az", "Arizona",
  "ar", "Arkansas",
  "ca", "California",
  "co", "Colorado",
  "ct", "Connecticut",
  "de", "Delaware",
  "fl", "Florida",
  "ga", "Georgia",
  "hi", "Hawaii",
  "id", "Idaho",
  "il", "Illinois",
  "in", "Indiana",
  "ia", "Iowa",
  "ks", "Kansas",
  "ky", "Kentucky",
  "la", "Louisiana",
  "me", "Maine",
  "md", "Maryland",
  "ma", "Massachusetts",
  "mi", "Michigan",
  "mn", "Minnesota",
  "ms", "Mississippi",
  "mo", "Missouri",
  "mt", "Montana",
  "ne", "Nebraska",
  "nv", "Nevada",
  "nh", "New Hampshire",
  "nj", "New Jersey",
  "nm", "New Mexico",
  "ny", "New York",
  "nc", "North Carolina",
  "nd", "North Dakota",
  "oh", "Ohio",
  "ok", "Oklahoma",
  "or", "Oregon",
  "pa", "Pennsylvania",
  "ri", "Rhode Island",
  "sc", "South Carolina",
  "sd", "South Dakota",
  "tn", "Tennessee",
  "tx", "Texas",
  "ut", "Utah",
  "vt", "Vermont",
  "va", "Virginia",
  "wa", "Washington",
  "wv", "West Virginia",
  "wi", "Wisconsin",
  "wy", "Wyoming"
)

write.csv(state_map, "states.csv")


# Filtering the data:
USA_df <- raw_df %>% mutate(tolower(state,country))
