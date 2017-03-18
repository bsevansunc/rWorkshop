# Script to generate color combinations.
#===============================================================================*
# ---- FUNCTIONS ----
#===============================================================================*

# Function to generate color combos:

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

# Function to return a data frame of color combos, given a data frame of used combos:

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

# Perhaps we have a data frame of used combos

usedCombos <- jayCombos %>%
  sample_n(100)

# We can use the getUnusedCombos function to get new combos:

newCombos <- getUnusedCombos(jayCombos, usedCombos)

# Let's see:

nrow(jayCombos)

nrow(usedCombos)

nrow(newCombos)



