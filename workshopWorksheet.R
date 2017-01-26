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

#=================================================================================*
# ---- DPLYR REVIEW ----
#=================================================================================*

# Read the data:

dirtyBird <- readWorkshopData('dirtyBirdData')

dirtyBanding <- readWorkshopData('dirtyBandingData')

dirtyResight <- readWorkshopData('dirtyResightData')
