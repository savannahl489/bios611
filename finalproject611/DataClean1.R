# Do target_interests align with the same as user interests?
setdiff(names(user2), names(ads2)) # Yes

#libraries:

library(tidyverse)

# dataloading:

ade <- read.csv('source_data/ad_events.csv')
ads <- read.csv('source_data/ads.csv')
camp <- read.csv('source_data/campaigns.csv')
user <- read.csv('source_data/users.csv')

# cleaning up ads and users interests variable with onehot encoding
user2 <- user %>%
  mutate(user_interests = strsplit(interests, ",\\s*")) %>%  # split by comma + optional space
  unnest(user_interests) %>%
  mutate(value = 1) %>%
  pivot_wider(
    names_from = user_interests,
    values_from = value,
    values_fill = 0
  )

write.csv(user2, 'derived_data/user_cleaned.csv') # user_cleaned done

