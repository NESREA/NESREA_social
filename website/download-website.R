## download-website.R

setwd(file.path(rootDir, "website"))
source("website-functions.R")

page <- news <- read_html("http://www.nesrea.gov.ng/news/")

headers <- scrape_items(".entry-header a")
descr <- scrape_items(".short-description p") %>%
  .[. != ""]
date <- scrape_items(".sponsors")

df <- data.frame(Title = headers, Description = descr, Date = date)

df