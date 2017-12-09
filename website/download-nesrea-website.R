## download-website.R
cat("** ")
setwd(file.path(rootDir, "website"))

## Preps
pkgs <- c("rvest", "DBI", "RSQLite", "dplyr", "stringr")
ensure_packages(pkgs)
source("website-functions.R")

## Download the NESREA 'News' page as an XML document
news <- read_html("http://www.nesrea.gov.ng/news/")

## Make a dataframe from vectors of text scraped from
## parts of the page via CSS selectors
headers <- scrape_items(page = news, ".entry-header a")

descr <- scrape_items(page = news, ".short-description p") %>%
  .[. != ""]

date <- scrape_items(page = news, ".sponsors") %>%
  gsub("([[:digit:]])(st|rd|nd|th)", "\\1", .) %>%
  str_trim() %>%
  strptime(format = "%B %d, %Y") %>%
  as.Date()

df <- data.frame(Title = headers,
                 Description = descr,
                 Date = date)

## Write it to the database
cat("** Connecting the database\n")
db <- dbConnect(SQLite(), file.path(rootDir, "data/nesreanigeria.db"))
dbWriteTable(db, "nesreanigeria_webnews", df, overwrite = TRUE)
# TODO: Provide storage for blogs
cat("** Checking for and correcting duplications")
tmp <- dbReadTable(db, "nesreanigeria_webnews") %>%
  distinct()
dbWriteTable(db, "nesreanigeria_webnews", tmp, overwrite = TRUE)
cat("......Done.\n")
  
cat("** Disconnecting the database\n")
dbDisconnect(db)

setwd("../")