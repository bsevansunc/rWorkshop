# Advanced wrangling, review and more!
#===============================================================================*
# ---- SET-UP ----
#===============================================================================*

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

# Load and potentially install libraries:

smartInstallAndLoad(c('RCurl', 'tidyverse', 'stringr',
                      'lubridate', 'geosphere'))

# Options and assigning a library to conflicting functions:

options(stringsAsFactors = FALSE)

select <- dplyr::select
summarize <- dplyr::summarize
rename <- dplyr::rename

# This function loads data frames from github:

readWorkshopData <- function(dataset){
  gitSite <- 'https://raw.githubusercontent.com/bsevansunc/rWorkshop/master/workshopData/'
  dataURL <-  getURL(paste0(gitSite, dataset,'.csv'))
  dataFrame <- read_csv(dataURL)
  return(dataFrame)
}

# Data for today's workshop:

birdTable <- readWorkshopData('birdTable')

captureTable <- readWorkshopData('captureTable')

siteIdTable <- readWorkshopData('siteIdentifierTable')

siteLocationTable <- readWorkshopData('siteLocationTable')

visitTable <- readWorkshopData('visitTable')

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

#===============================================================================*
# ---- THE PROBLEM ----
#===============================================================================*
# From: MarraP@si.edu
# Date: 2017-02-20
# Subject line:
# Message content (in it's entirety): O/a, g
# Later reply: what about P/A, G?

# Start by having a look at the tables:


birdTable

captureTable

siteIdTable

siteLocationTable

visitTable

# And now, the sleuthing:


#===============================================================================*
# ---- THE RESPONSE ----
#===============================================================================*
# what about P/A, G?
