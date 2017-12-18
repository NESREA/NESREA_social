## download-website.R
setwd(file.path(rootDir, "website"))

## Preps
pkgs <- c("rvest", "DBI", "RSQLite", "dplyr", "stringr")
ensure_packages(pkgs)
source("website-functions.R")

## Download the NESREA 'News' page as an XML document
url <- "http://www.nesrea.gov.ng/news/"
news <- read_html(url)
cat("URL:", url, "\n")

## Make a dataframe from vectors of text scraped from
## parts of the page via CSS selectors
headers <- scrape_items(page = news, ".entry-header a", verbose = TRUE)

descr <- scrape_items(page = news, ".short-description p", verbose = TRUE) %>%
  .[. != ""]

date <- scrape_items(page = news, ".sponsors", verbose = TRUE) %>%
  gsub("([[:digit:]])(st|rd|nd|th)", "\\1", .) %>%
  str_trim() %>%
  strptime(format = "%B %d, %Y") %>%
  as.Date()

df <- data.frame(Title = headers,
                 Description = descr,
                 Date = date)

## Write it to the database
cat("Connecting the database.... ")
db <- dbConnect(SQLite(), file.path(rootDir, "data/nesreanigeria.db"))
cat("DONE\nStore website data....")
dbWriteTable(db, "nesreanigeria_webnews", df, overwrite = TRUE)
# TODO: Provide storage for blogs
cat("DONE\nChecking for and correcting duplications... ")
tmp <- dbReadTable(db, "nesreanigeria_webnews") %>%
  distinct()
dbWriteTable(db, "nesreanigeria_webnews", tmp, overwrite = TRUE)
cat("DONE\n")
  
cat("Disconnecting the database...")
dbDisconnect(db)
cat("DONE\n")

setwd("../")