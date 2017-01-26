# Today's libraries:

library(RCurl)
library(tidyverse)
library(lubridate)
library(stringr)

gitSite <- 'https://raw.githubusercontent.com/bsevansunc/rWorkshop/master/'

dirtyBirdURL <- getURL(paste0(gitSite, 'dirtyBirdData','.csv'))

dirtyBandingURL <- getURL(paste0(gitSite, 'dirtyBandingData','.csv'))

dirtyResightURL <- getURL(paste0(gitSite, 'dirtyResightData','.csv'))

#=================================================================================*
# ---- SET-UP ----
#=================================================================================*

# First, a better way to read files than read.csv:

dirtyBird <- read_csv(dirtyBirdURL)
  
dirtyBanding <- read_csv(dirtyBandingURL)

dirtyResight <- read_csv(dirtyResightURL)

#=================================================================================*
# ---- WORKING WITH STRINGS ----
#=================================================================================*

# Some work with strings in stringr:

dirtyBird

# Let's take a look at the species observed:

sp <- dirtyBird$speciesEnc %>% unique

# Obviously punctuation is a big problem in this dataset. We can use the
# function str_to_upper to change the case:

sp %>% str_to_upper

# Detect a string:

str_detect(dirtyBird$bandNumber, '\t')

# Filter based on a detection:

dirtyBird %>%
  filter(str_detect(bandNumber, '\t'))

# Subset to just the first record:

string <- dirtyBird$bandNumber[1]

# Trim strings:

string %>%
  str_trim

# Replace values in a string:

string %>%
  str_replace_all('[a-z]','')

# Replace and trim: 

string %>%
  str_trim %>%
  str_replace_all('[a-z]','')

# Subset by position (band prefix):

string %>%
  str_sub(end = -6)

# Replace, trim, subset (band prefix):

string %>%
  str_trim %>%
  str_replace_all('[a-z]','') %>%
  str_sub(end = -6)

# Pasting strings (band prefix and suffix):

bandPrefix <- string %>%
  str_trim %>%
  str_replace_all('[a-z]','') %>%
  str_sub(end = -6)

bandSuffix <-  string %>%
  str_trim %>%
  str_replace_all('[a-z]','') %>%
  str_sub(start = -5)

paste(bandPrefix, bandSuffix, sep = '-')

# Make into a function:

addDashFun <- function(bandNumber){
  bandPrefix <- bandNumber %>%
    str_trim %>%
    str_replace_all('[a-z]','') %>%
    str_sub(end = -6)
  bandSuffix <-  bandNumber %>%
    str_trim %>%
    str_replace_all('[a-z]','') %>%
    str_sub(start = -5)
  paste(bandPrefix, bandSuffix, sep = '-')
}

# Try out the function

addDashFun('293048233')
addDashFun('93048233')
addDashFun('930-48233')

# Function failed! What do we need to do?

addDashFun <- function(bandNumber){
  bandPrefix <- bandNumber %>%
    str_trim %>%
    str_replace_all('[a-z]','') %>%
    str_replace_all('-','') %>%
    str_sub(end = -6)
  bandSuffix <-  bandNumber %>%
    str_trim %>%
    str_replace_all('[a-z]','') %>%
    str_replace_all('-','') %>%
    str_sub(start = -5)
  paste(bandPrefix, bandSuffix, sep = '-')
}

# Try out the function:

addDashFun('930-48233')

# Read in the data again, with pipe to fix the band numbers:

dirtyBird <- read_csv(dirtyBirdURL) %>%
  mutate(bandNumber = addDashFun(bandNumber))

dirtyBanding <- read_csv(dirtyBandingURL) %>%
  mutate(bandNumber = addDashFun(bandNumber))

dirtyResight <- read_csv(dirtyResightURL) %>%
  mutate(bandNumber = addDashFun(bandNumber))

# We may want to ensure that '\t' is nowhere in the database, we can use mutate_all for this:

read_csv('dirtyBirdData.csv') %>%
  mutate_all(funs(str_trim))

# A challenge! Read in the data, now fixing the band numbers, species names, and
# trimming all fields:

dirtyBird <- read_csv(dirtyBirdURL) %>%
  mutate(bandNumber = addDashFun(bandNumber),
         speciesEnc = str_to_upper(speciesEnc)) %>%
  mutate_all(funs(str_trim))

dirtyBanding <- read_csv(dirtyBandingURL) %>%
  mutate(bandNumber = addDashFun(bandNumber)) %>%
  mutate_all(funs(str_trim))

dirtyResight <- read_csv(dirtyResightURL) %>%
  mutate(bandNumber = addDashFun(bandNumber)) %>%
  mutate_all(funs(str_trim))

#=================================================================================*
# ---- COMBINING DATA TABLES ----
#=================================================================================*

# Joining based on common columns:

dirtyBirdBanding <- left_join(
  dirtyBird,
  dirtyBanding,
  by = 'bandNumber'
)

dirtyBirdResight <- inner_join(
  dirtyBird,
  dirtyResight,
  by = 'bandNumber'
)

# Combining rows:

bind_rows(dirtyBirdBanding, dirtyBirdResight)

# Joining and combining data in one step, method 1:

bind_rows(
  left_join(dirtyBird, dirtyBanding, by = 'bandNumber'),
  inner_join(dirtyBird, dirtyResight, by = 'bandNumber')
)

# Joining and combining data in one step, method 2:

birdData <- left_join(dirtyBird, dirtyBanding, by = 'bandNumber') %>%
  bind_rows(inner_join(dirtyBird, dirtyResight, by = 'bandNumber'))

# Challenge: Read, fix, join, and bind in one step:

#=================================================================================*
# ---- WORKING WITH DATES ----
#=================================================================================*

class(birdData$date)

date1 <- birdData$date[1]

as.Date(date1)

# Converting to a date object:

as.Date(date1, '%m/%d/%Y')

# Get year from the date object:

date1 %>%
  as.Date('%m/%d/%Y') %>%
  year

# Why work with date objects? They can provide lots of flexibility!

date1 %>%
  as.Date('%m/%d/%Y') %>%
  day

date1 %>%
  as.Date('%m/%d/%Y') %>%
  month

date1 %>%
  as.Date('%m/%d/%Y') %>%
  month(label = TRUE)

date1 %>%
  as.Date('%m/%d/%Y') %>%
  month(label = TRUE, abbr = FALSE)

date1 %>%
  as.Date('%m/%d/%Y') %>%
  yday

date1 %>%
  as.Date('%m/%d/%Y') %>%
  week

date1 %>%
  as.Date('%m/%d/%Y') %>%
  wday

date1 %>%
  as.Date('%m/%d/%Y') %>%
  wday(label = TRUE)

date1 %>%
  as.Date('%m/%d/%Y') %>%
  wday(label = TRUE, abbr = FALSE)

# Fix in the birdData data table and add a year field:

birdData <- left_join(dirtyBird, dirtyBanding, by = 'bandNumber') %>%
  bind_rows(inner_join(dirtyBird, dirtyResight, by = 'bandNumber')) %>%
  mutate(date = as.Date(date, '%m/%d/%Y'),
         year = year(date))

# Take a look:

View(birdData)

# Challenge: Read, fix, join, bind, fix dates and add year in one step:

#=================================================================================*
# ---- SELECTING ONLY PERTINENT FIELDS (REVIEW) ----
#=================================================================================*

# We can select columns from our data:

birdData %>%
  select(bandNumber:date)

birdData %>%
  select(bandNumber, date)

# Or make an inverse selection:

birdData %>%
  select(-breedingCond)

birdData %>%
  select(-c(breedingCond:rsLat))

# Let's use select to remove the measurement data to, to make it the data frame 
# more manageable:

birdData <- left_join(dirtyBird, dirtyBanding, by = 'bandNumber') %>%
  bind_rows(inner_join(dirtyBird, dirtyResight, by = 'bandNumber')) %>%
  mutate(date = as.Date(date, '%m/%d/%Y'),
         year = year(date)) %>%
  select(-c(breedingCond:rsLat))
  
# Challenge: Read, fix, join, bind, fix dates, add year, and select columns in
# one step:


#=================================================================================*
# ---- SUBSETTING WITH %in% ----
#=================================================================================*

# Get vector of unique species:

unique(birdData$speciesEnc)

# Perhaps we're only interested for banding data on NOCA and GRCA, let's look at
# what %in% does:

unique(birdData$speciesEnc) %in% c('NOCA', 'GRCA')

# We can use this to filter the birdData:

birdData %>%
  filter(speciesEnc %in% c('NOCA', 'GRCA'))

# Conversely, we may want to remove just the Red-bellied woodpecker, as it is
# not a Nestwatch species:

!unique(birdData$speciesEnc) %in% 'RBWO'

birdData %>%
  filter(!speciesEnc %in% 'RBWO')

#=================================================================================*
# ---- SUBSETTING AND SUMMARIZING ----
#=================================================================================*

# Recall that we can use summarize to provide summary stats of a data table, including the number of records:

birdData %>%
  summarize(n = n_distinct(bandNumber))

# Group by allows us to summarize by a grouping variable:

birdData %>%
  group_by(speciesEnc) %>%
  summarize(n = n_distinct(bandNumber))

# Perhaps we want to allow only one observation of a bird per year and we are
# simply trying to summarize the number of encounters for a bird, we can use
# select and distinct to get only the unique records of a bird for a given year:

birdData %>%
  select(bandNumber, speciesEnc, year) %>%
  distinct

# For a simple summary, let's look at the number of birds banded for each
# species and year:

birdData %>%
  select(bandNumber, speciesEnc, year) %>%
  distinct %>%
  group_by(speciesEnc, year) %>%
  summarize(n = n_distinct(bandNumber))


# Let's add a filter to look at the number of Gray catbirds that were
# encountered each year of the project:

birdData %>%
  select(bandNumber, speciesEnc, year) %>%
  filter(speciesEnc == 'GRCA') %>%
  distinct %>%
  group_by(year) %>%
  summarize(n = n_distinct(bandNumber))

# Let's look at the number of Gray catbirds that were banded in 2015:

birdData %>%
  filter(speciesEnc == 'GRCA',
         encounterType == 'Band',
         year == 2015) %>%
  select(bandNumber, speciesEnc, year) %>%
  distinct %>%
  summarize(n = n_distinct(bandNumber))

# Let's look at the number of Gray catbirds that were banded during each year of
# the project:

birdData %>%
  filter(speciesEnc == 'GRCA',
         encounterType == 'Band') %>%
  select(bandNumber, speciesEnc, year) %>%
  distinct %>%
  group_by(year) %>%
  summarize(n = n_distinct(bandNumber))



# Or the number of Gray catbirds that were banded or recaptured in 2015:

birdData %>%
  filter(speciesEnc == 'GRCA',
         encounterType %in% c('Band', 'Recap'),
         year == 2015) %>%
  select(bandNumber, speciesEnc, encounterType, year) %>%
  distinct %>%
  group_by(encounterType) %>%
  summarize(n = n_distinct(bandNumber))

# A challenge! Take a look at the number of Gray catbirds and Northern Cardinals
# banded and recaptured by month in 2015:







