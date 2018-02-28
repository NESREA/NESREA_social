## download-website.R

## Preps
ensure_packages(c("rvest", "DBI", "RSQLite", "dplyr", "rprojroot", "stringr"))
source(find_root_file("website", "website-functions.R", criterion = rootCrit))

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
                 Date = date,
                 stringsAsFactors = FALSE)

## Write it to the database
cat("Connecting the database.... ")
db <- 
  dbConnect(SQLite(),
            find_root_file("data", "nesreanigeria.db", criterion = rootCrit))
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

if (dbIsValid(db)) {
  cat("Database was not disconnected.")
} else cat("DONE\n")
