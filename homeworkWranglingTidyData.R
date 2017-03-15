# R Homework!
#=================================================================================*
# ---- SET-UP ----
#=================================================================================*

# Start by running the functions below. It is not necessary to understand these
# functions, unless you really want to.

#---------------------------------------------------------------------------------*
# ---- FUNCTIONS
#---------------------------------------------------------------------------------*

# Smart installer will check list of packages that are installed, install any
# necessary package that is missing, and load the library:

smartInstallAndLoad <- function(packageVector){
  for(i in 1:length(packageVector)){
    package <- packageVector[i]
    if(!package %in% rownames(installed.packages())){
      install.packages(packageVector[i],repos="http://cran.rstudio.com/",
                       dependencies=TRUE)
    }
  }
  lapply(packageVector, library, character.only = TRUE)
}

# This function loads data frames from github:

readWorkshopData <- function(gitSite, dataset){
  dataURL <-  getURL(paste0(gitSite, dataset,'.csv'))
  dataFrame <- read_csv(dataURL)
  return(dataFrame)
}

# This function returns a vector of sites within a given distance from the
# target site:

sitesByDistance <- function(targetSite, maxDistance){
  # Subset site location table to target site:
  targetFrame <- siteLocationTable %>%
    filter(siteID == targetSite) %>%
    select(siteID, long, lat) %>%
    left_join(siteIdTable, by = 'siteID')
  # Get all points with latitude and longitude, subset to region:
  allSitesSubset <- siteLocationTable %>%
    left_join(siteIdTable, by = 'siteID') %>%
    filter(!is.na(long),
           !is.na(lat),
           region == targetFrame$region) %>%
    select(siteID, long, lat)
  # Make spatial:
  targetSiteSp <- SpatialPoints(
    targetFrame[,c('long','lat')], 
    proj4string = CRS('+proj=longlat +datum=WGS84'))
  # Make remaining points a spatial points data frame:
  allSitesSubsetSp <- SpatialPoints(
    allSitesSubset[,c('long','lat')], 
    proj4string = CRS('+proj=longlat +datum=WGS84'))
  # Calculate the distance between all sites and target site:
  siteSubset <- allSitesSubset %>%
    select(siteID) %>%
    mutate(siteDist = distm(targetSiteSp, allSitesSubsetSp) %>%
             as.vector) %>%
    filter(siteDist < maxDistance) %>%
    .$siteID
  return(siteSubset)
}

#---------------------------------------------------------------------------------*
# ---- LOAD DATA AND LIBRARIES, SET OPTIONS ---
#---------------------------------------------------------------------------------*

# Load and potentially install libraries:

smartInstallAndLoad(c('tidyverse', 'stringr', 'lubridate',
                      'RCurl', 'sp','geosphere'))

# Options and assigning a library to conflicting functions:

options(stringsAsFactors = FALSE)

select <- dplyr::select
summarize <- dplyr::summarize
rename <- dplyr::rename

# Provide address of github data:

gitSite <- 'https://raw.githubusercontent.com/bsevansunc/rWorkshop/master/workshopData/'

# Data for today's workshop:

birdTable <- readWorkshopData(gitSite, 'birdTable')

captureTable <- readWorkshopData(gitSite, 'captureTable')

siteIdTable <- readWorkshopData(gitSite, 'siteIdentifierTable')

siteLocationTable <- readWorkshopData(gitSite, 'siteLocationTable')

visitTable <- readWorkshopData(gitSite, 'visitTable')

#=================================================================================*
# ---- ASSIGNMENT ----
#=================================================================================*

# Instructions: 
# a) For each of the following tasks, use tidyverse (tidyr and
#    dplyr) functions. 
# b) Below each task prompt, provide the code used to complete the task. There is
#    no need to provide an answer but the output of the code must directly solve
#    the task (see examples below).
# c) Unless asked to do so, do not assign names to output tables (i.e., each
#    task must begin with the raw data). 

#---------------------------------------------------------------------------------*
# ---- EXAMPLES ---
#---------------------------------------------------------------------------------*

# Example 1. Subset birdTable to only NOCA records:

birdTable %>%
  filter(species == 'NOCA')

# Example 2. Determine the number of NOCA records in birdTable:

birdTable %>%
  filter(species == 'NOCA') %>%
  nrow

# Example 3. Subset captureTable to only the fields birdID, visitID, age, and sex:

captureTable %>%
  select(birdID, visitID, age, sex)

# Example 4. Join birdTable to a subset of captureTable that includes only the columns birdID, visitID, age, and sex:

birdTable %>%
  left_join(
    captureTable %>%
      select(birdID, visitID, age, sex),
    by = 'birdID'
  )

#---------------------------------------------------------------------------------*
# ---- NOW YOU ---
#---------------------------------------------------------------------------------*

# 1. Subset the siteIdTable to only sites from the region 'Springfield':

siteIdTable %>%
  filter(region == 'Springfield')

# 2. Subset the siteIdTable to only the fields siteID and region:

siteIdTable %>%
  select(siteID, region)

# 3. Subset the siteLocation Table to only locations in Amherst, Massachussetts:

siteLocationTable %>% 
  filter(city == 'Amherst')

# 4. Subset the siteLocationTable to only locations in Monson, Amherst, and
# Belchertown Massachussetts:

siteLocationTable %>% 
  filter(city %in% c('Monson', 'Amherst','Belchertown'))

# 5. Subset the siteLocationTable to only locations in Monson, Amherst, and 
# Belchertown Massachussetts and subset the resultant frame to the fields
# siteID, houseNumber, street, city, state, and zip:

siteLocationTable %>% 
  filter(city %in% c('Monson', 'Amherst','Belchertown')) %>%
  select(siteID, houseNumber:zip)

# 6. Using the functions, select, filter, and distinct subset the siteLocationTable such that the output is a data table of unique cities studied in  Massachussets:

siteLocationTable %>%
  select(city, state) %>%
  filter(state == 'MA') %>%
  distinct

# 7. The function 'year()' can be used to extract the year from a date object.
# Subset the visitTable to only visits from 2015:

visitTable %>%
  filter(year(dateVisit) == 2015)

# 8. Subset the visitTable to visitID, siteID, and dateVisit, and use 'left_join'
# to join the resultant table to the siteIdentifierTable by siteID:

visitTable %>%
  select(visitID, siteID, dateVisit) %>%
  left_join(siteIdTable, by = 'siteID')

# 9. Subset the visitTable to visitID, siteID, and dateVisit, and use 'left_join'
# to join the resultant table to the siteIdentifierTable by siteID, then subset the columns to visitID, siteID, dateVisit, and region:

visitTable %>%
  select(visitID, siteID, dateVisit) %>%
  left_join(siteIdTable, by = 'siteID') %>%
  select(visitID, siteID, dateVisit, region)

# 10. Subset the visitTable to visitID, siteID, and dateVisit, and use
# 'left_join' to join the resultant table to the siteIdentifierTable by siteID,
# subset the columns to visitID, siteID, dateVisit, and region, then filter to
# only visits in the Springfield region in 2013:

visitTable %>%
  select(visitID, siteID, dateVisit) %>%
  left_join(siteIdTable, by = 'siteID') %>%
  select(visitID, siteID, dateVisit, region) %>%
  filter(year(dateVisit) == 2013, region == 'Springfield')

# 11. Calculate how many visits there were in the DC region in 2008:

visitTable %>%
  select(visitID, siteID, dateVisit) %>%
  left_join(siteIdTable, by = 'siteID') %>%
  select(visitID, siteID, dateVisit, region) %>%
  filter(year(dateVisit) == 2008, region == 'DC') %>%
  select(visitID) %>%
  distinct %>%
  nrow

# 12. Use the birdTable with group_by and summarize functions calculate how many
# birds of each species have been banded by Neighborhood Nestwatch. Name the
# summary column "tSpecies":

birdTable %>%
  group_by(species) %>%
  summarize(tSpecies = n())

# 13. There's a lot of extraneous species in the results from number 12. Use my
# focal species vector below to subset the birdTable to just our species of
# interest and calculate how many birds of our focal species have been banded by
# Neighborhood Nestwatch. Name the summary column "tSpecies":

focalSpecies <- c('AMRO', 'BCCH', 'BRTH', 'CACH', 'CARW', 'GRCA', 'HOWR',
                  'NOCA', 'NOMO', 'SOSP', 'TUTI')

birdTable %>%
  filter(species %in% focalSpecies) %>%
  group_by(species) %>%
  summarize(tSpecies = n())

# 14. Subset the birdTable to the columns birdID and species. Join the capture
# table to the birdTable and subset the resultant table to the columns birdID,
# species, visitID, typeCapture, colorComboL, colorComboR, and sex:

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex)

# 15. Repeat #14 and use the resultant table to calculate the number of male (M)
# and female (F) NOCA that have been banded (typeCapture == 'B') by Neighborhood
# Nestwatch:

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  filter(species == 'NOCA') %>%
  filter(typeCapture == 'B') %>%
  group_by(sex) %>%
  summarize(tCaptures = n()) %>%
  filter(sex %in% c('M', 'F'))

# 16. Repeat #14 and join to the visitTable, subset to the columns visitID,
# siteID, and dateVisit, by 'visitID':

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID')

# 17. Repeat #16 and calculate the number of birds of each focal species that were banded of each sex in 2016:

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID') %>%
  filter(year(dateVisit) == 2016) %>%
  filter(typeCapture == 'B') %>%
  filter(species %in% focalSpecies) %>%
  group_by(species) %>%
  summarize(tBanded = n())

# 18. Repeat #16 and join the resultant table with the siteIdTable, subset to the siteID and region columns.

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID') %>%
  left_join(siteIdTable %>%
              select(siteID, region))

# 19. Calculate how many male and female NOCA were banded in the Pittsburgh region in 2016:

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID') %>%
  left_join(siteIdTable %>%
              select(siteID, region)) %>%
  filter(region == 'Pittsburgh',
         year(dateVisit) == 2015,
         species == 'NOCA',
         typeCapture == 'B') %>%
  group_by(sex) %>%
  summarize(tBanded = n()) %>%
  filter(sex %in% c('F', 'M'))

# 20. Subset #18 above to female NOCA that were banded in the Springfield region
# with a purple (M) band on the left leg:

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID') %>%
  left_join(siteIdTable %>%
              select(siteID, region)) %>%
  filter(region == 'Springfield',
         species == 'NOCA', 
         sex == 'F',
         str_detect(colorComboL, 'M'))

# 21. Below I used the sitesByDistance function to calculate a vector of sites
# within 2 km of Susannah Lerman's first Nestwatch site, LERMSUSMA1. Susannah
# spotted a Gray Catbird with aluminum (X) over green (G) on the left leg and
# red (R)  on the right, but there is no bird with that combination from her
# site! Find out where this bird was captured:

sitesByDistance('LERMSUSMA1', 2000)

birdTable %>%
  select(birdID, species) %>%
  left_join(captureTable, by = 'birdID') %>%
  select(birdID:visitID, typeCapture, colorComboL, colorComboR, sex) %>%
  left_join(visitTable %>%
              select(visitID, siteID, dateVisit), by = 'visitID') %>%
  left_join(siteIdTable %>%
              select(siteID, region)) %>%
  filter(siteID %in% sitesByDistance('LERMSUSMA1', 2000),
         species == 'GRCA',
         str_detect(colorComboL, 'XG'),
         str_detect(colorComboR, 'R'))
         

