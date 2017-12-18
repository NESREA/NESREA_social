## website-functions.R

## Convenienly collect data based on CSS selector
## and return it as a character vector
scrape_items <- function(page, selector, verbose = FALSE) {
  if (verbose)
    cat("Scraping data linked to the", sQuote(selector), "CSS selector.....")
  
  txt <- page %>%
    html_nodes(selector) %>%
    html_text()
  
  if (!length(txt)) {
    if (verbose) {
      cat("NO DATA")
    }
    warning("It is likely that a wrong CSS selector was used")
  } else {
    if (verbose)
      cat("DONE\n")
    txt
  }
}