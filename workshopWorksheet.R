# Advanced data wrangling

#=================================================================================*
# ---- SET-UP ----
#=================================================================================*

# Load the following functions (it is not necessary to understand them):

# This function checks to see if all of the packages we will use are installed
# and installs them if you don't and loads the libraries):

smartLibrary <- function(packages){
  packagesToInstall <- packages[!(packages) %in% installed.packages()]
  if(length(packagesToInstall) != 0){
    install.packages(packagesToInstall, dependencies = TRUE) 
  }
  lapply(packages, require, character.only = TRUE)
}

# This function loads data frames from github:

readWorkshopData <- function(dataset){
  gitSite <- 'https://raw.githubusercontent.com/bsevansunc/rWorkshop/master/'
  dataURL <-  getURL(paste0(gitSite, dataset,'.csv'))
  dataFrame <- read_csv(dataURL)
  return(dataFrame)
}

# Load libraries:

smartLibrary(c('RCurl', 'tidyverse', 'lubridate', 'stringr'))

#=================================================================================*
# ---- TIDYR REVIEW ----
#=================================================================================*

# Read the data:

wideFrame <- readWorkshopData('tidyrReview')

# gather: Use to convert from wide to long frame:

wideFrame %>%
  gather(key = year,
         value = measuredValue,
         mass_2016:mass_2017)

# gather with na.rm: Remove NA when gathering

wideFrame %>%
  gather(key = year,
         value = measuredValue,
         mass_2016:mass_2017,
         na.rm = TRUE)

# separate: Use to separate columns

wideFrame %>%
  gather(key = year,
         value = measuredValue,
         mass_2016:mass_2017,
         na.rm = TRUE) %>%
  separate(col = year,
           into = c('variable', 'year'),
           sep = '_')

# arrange: sort data frame by variable (ascending)

wideFrame %>%
  gather(key = year,
         value = measuredValue,
         mass_2016:mass_2017,
         na.rm = TRUE) %>%
  separate(col = year,
           into = c('variable', 'year'),
           sep = '_') %>%
  arrange(subject)

# arrange: sort data frame by variable (descending)

wideFrame %>%
  gather(key = year,
         value = measuredValue,
         mass_2016:mass_2017,
         na.rm = TRUE) %>%
  separate(col = year,
           into = c('variable', 'year'),
           sep = '_') %>%
  arrange(desc(subject))

# NOW YOU: Load the following dirty data frame, make it long (removing NA's),
# use separate to clean the values, and arrange by date (ascending):

tidyExercise <- readWorkshopData('tidyExercise')

#=================================================================================*
# ---- DPLYR REVIEW ----
#=================================================================================*

dplyrReview <- readWorkshopData('dplyrReview')

dplyrReview

# rename: Rename columns of a data frame

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE)

# filter: Subset rows in a data table using logical conditions  

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(encounterType == 'Band') %>%
  filter(sex != 'U') %>%
  filter(age != 'HY', sex == 'F')

# filter ... using %in%

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(age %in% c('AHY','ASY', 'SY', 'AHY\t','ASH'))

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(!(age %in% c('U', 'UNK', 'HY')))
  
# select: Subset columns in a data table  

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(encounterType == 'Band') %>%
  filter(sex != 'U') %>%
  filter(age != 'HY', sex == 'F') %>%
  select(bandNumber, fat:tarsus) %>%
  select(-c(fat, tarsus))

# left_join: Bind data tables by common columns

dirtyBirds <- readWorkshopData('dirtyBirdData')

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(encounterType == 'Band',
         age != 'HY', sex == 'F') %>%
  select(bandNumber, mass:tl) %>%
  left_join(dirtyBirds, by = 'bandNumber')

# bind_cols: Bind the rows of columns of data tables together by position

dataLeft <-
  
dataRight <-
  
bind_cols(dataLeft, dataRight)

# bind_rows: Bind the rows of two data tables together by position

dataTop <- 
  
dataBottom <-
  
bind_rows(dataTop, dataBottom)

# mutate: Compute and append a new column to a data table

dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(encounterType == 'Band',
         age != 'HY', sex == 'F') %>%
  select(bandNumber, mass:tl) %>%
  left_join(dirtyBirds, by = 'bandNumber') %>%
  mutate(mass = as.numeric(mass))

# mutate_all: Apply a computation to all columns in a data table:

dplyrReviewClean <- dplyrReview %>%
  rename(date = date.Of.Encounter,
         encounterType = ENCOUNTER.TYPE) %>%
  filter(encounterType == 'Band',
         age != 'HY', sex == 'F') %>%
  select(bandNumber, mass:tl) %>%
  left_join(dirtyBirds, by = 'bandNumber')

dplyrReviewClean %>%
  select(mass, wing, tl) %>%
  mutate_all(as.numeric)

## Next: bind_cols with bandNumber, species.

dplyrReviewClean %>%
  select(mass, wing, tl) %>%
  mutate_all(as.numeric)

# group_by: Group rows of data by some grouping variable

# summarize: Calculate summary information for groups



