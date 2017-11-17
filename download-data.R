## download-data.R

tw <- "* Twitter"
fb <- "* Facebook"
beg <- "downloads started\n"
end <- "downloads completed\n"

cat(tw, beg)
source("twitter/download-nesrea-tweets.R")
cat(tw, end)

cat(fb, beg)
source("facebook/download-nesrea-fbposts.R")
cat(fb, end)

rm(tw, fb, beg, end)
