## website-functions.R

## Convenienly collect data based on CSS selector
## and return it as a character vector
scrape_items <- function(page, selector) {
  txt <- page %>%
    html_nodes(selector) %>%
    html_text()
  txt
}