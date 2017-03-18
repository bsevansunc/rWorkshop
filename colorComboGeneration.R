# Script to generate color combinations.

#===============================================================================*
# ---- SET UP ----
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

smartInstallAndLoad(c('tidyverse', 'stringr', 'lubridate'))

#===============================================================================*
# ---- FUNCTIONS ----
#===============================================================================*

# Function to generate color combinations:
# Inputs are:
# - colorVector: A vector of colors (does not include aluminum)
# - nBands: The number of total bands (including aluminum)
# - xPositions: The location of the aluminum band (defaults to any):
#     * 1 = Left leg, top
#     * 2 = Left leg, bottom
#     * 3 = Right leg, top
#     * 4 = Right leg, bottom
# - aluminum: TRUE/FALSE (defaults to TRUE), whether you want combinations
#      that include an aluminum band

getColorCombos <- function(colorVector, nBands, 
                           xPositions = 1:4, aluminum = TRUE){
  if(aluminum == TRUE) colorVector <- c(colorVector, 'X')
  if(nBands!= 4) colorVector <- c(colorVector, '-')
  colorList <- rep(list(colorVector), 4)
  colorGrid <- expand.grid(colorList, stringsAsFactors = FALSE) %>%
    unite(col = combinedCol, 1:4, sep = '') %>%
    filter(str_count(combinedCol, '-') == 4 - nBands)
  if(aluminum == TRUE){
    colorGrid <- colorGrid %>%
      filter(str_count(combinedCol, 'X') == 1,
             str_locate(combinedCol, 'X')[,1] %in% xPositions)
  }
  colorCombos <- colorGrid %>%
    separate(col = combinedCol, into = c('colorL', 'colorR'), sep = 2) %>%
    mutate_all(str_replace_all, pattern = '-', replacement = '')
  return(
    sample_n(colorCombos, nrow(colorCombos)) %>%
      distinct
  )
}

# Function to return a data frame of color combos, given a data frame of used
# combos. Inputs include:
# - colorComboFrame: Generated color combination data frame from output of
#   getColorCombos, with the columns colorL and colorR
# - previousComboFrame: Data frame of used color combinations with the
#   columns colorL and colorR

getUnusedCombos <- function(colorComboFrame, previousComboFrame){
  newCombos <- colorComboFrame %>%
    anti_join(
      previousComboFrame,
      by = c('colorL', 'colorR')
    )
  return(
    sample_n(newCombos, nrow(newCombos))
  )
}

# Function to return a data frame of color combos, given a data frame of combos
# used and the last date in which a bird was observed. Inputs include:
# - colorComboFrame: Generated color combination data frame from output of
#   getColorCombos, with the columns colorL and colorR
# - comboDateFrame: Data frame of used color combinations with the
#   columns colorL and colorR and a date column (ISO 8601) with the last
#   date a bird was observed
# - yearBuffer: The number of years in which a color combination should be
#   exclude. This buffer is designed as "less than or equal to" so if, for
#   example, the year buffer is 3, the output would exlude any combination
#   used in the last 3 years.

getCombosByYearBuffer <- function(colorComboFrame, comboDateFrame, yearBuffer){
  currentYear <- year(Sys.Date())
  combosToExclude <- comboDateFrame %>%
    filter(currentYear - year(date) <= yearBuffer)
  return(
    getUnusedCombos(colorComboFrame, combosToExclude)
  )
}

#===============================================================================*
# ---- TRYING IT OUT ----
#===============================================================================*

# Blue Jay color vector:

jayColors <- c('B', 'G', 'O', 'Y', 'R','W')

# Get 4 band combination, with aluminum on the bottom:

jayCombos <- getColorCombos(jayColors, nBands = 4, xPositions = c(2,4))

# Non-native species? Don't use aluminum:

getColorCombos(jayColors, nBands = 4, aluminum = FALSE)

# Only three bands (with alumnimum on bottom):

getColorCombos(jayColors, nBands = 3, xPositions = c(2,4))

# Only three bands with aluminum at any position:

getColorCombos(jayColors, nBands = 3)

#-------------------------------------------------------------------------------*
# ---- TRYING IT OUT: UNUSED COMBOS ----
#-------------------------------------------------------------------------------*

# Let's use our jay combinations:

jayCombos <- getColorCombos(jayColors, nBands = 4, xPositions = c(2,4))

# And make a fake data frame of used combos:

usedCombos <- jayCombos %>%
  sample_n(100)

# We can use the getUnusedCombos function to get new combos:

newCombos <- getUnusedCombos(jayCombos, usedCombos)

# Let's see:

nrow(jayCombos)

nrow(usedCombos)

nrow(newCombos)

#-------------------------------------------------------------------------------*
# ---- TRYING IT OUT: NEW COMBOS AFTER A GIVEN NUMBER OF YEARS ----
#-------------------------------------------------------------------------------*

# Let's use our jay combinations again:

jayCombos <- getColorCombos(jayColors, nBands = 4, xPositions = c(2,4))

# I'm going to add a column of fake dates that represent the last day the jay
# was observed:

jayCombosDate <- jayCombos %>%
  mutate(date = sample(seq(as.Date('2005-01-01'),
                           Sys.Date(), by="day"), nrow(jayCombos))
)

# Now we can simply run the function to determine the combos that can be
# used:

getCombosByYearBuffer(jayCombos, jayCombosDate, yearBuffer = 5)

# Did it work? Let's check:

nrow(jayCombos)

jayCombosDate %>%
  filter(year(Sys.Date()) - year(date) > 5) %>%
  nrow

getCombosByYearBuffer(jayCombos, jayCombosDate, yearBuffer = 5) %>%
  nrow

# Yup!




