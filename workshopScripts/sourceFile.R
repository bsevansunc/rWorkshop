# SOURCE FILE

# Smart require checks computer for packages, downloads them if missing, and loads the libraries

smartRequire <- function(packages){
  # Get vector of packages listed that aren't on the current computer
  packagesToInstall <- packages[!package %in% rownames(installed.packages())]
  if(length(packagesToInstall > 0)){
    install.packages(packagesToInstall, dependencies = TRUE)
  }
  lapply(packages, require, character.only = TRUE)
}


