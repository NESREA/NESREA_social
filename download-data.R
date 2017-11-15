## download-data.R

txt <- "downloads completed\n"

source("twitter/download-nesrea-tweets.R")
cat("* Twitter", txt)

source("facebook/download-nesrea-fbposts.R")
cat("* Facebook", txt)

rm(txt)