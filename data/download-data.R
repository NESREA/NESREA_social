## download-data.R

pkg <- "rprojroot"
if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
  install.packages(pkg, repos = "http://cran.rstudio.com")
  
  Sys.sleep(5)
  
  if (!pkg %in% .packages(all.available = TRUE))
    stop(paste(sQuote(pkg), "was not installed."))
  else
    library(pkg, character.only = TRUE, quietly = TRUE)
}
rootCrit <- has_file("NESREA_social.Rproj")

source(find_root_file("data", "downloadfunctions-gen.R", criterion = rootCrit))
ensure_packages(c("DBI", "RSQLite"))

## Confirm availability of database
validate_db(find_root_file("data", "nesreanigeria.db", criterion = rootCrit))

## Download data from Twitter and Facebook, respectively
### Print appropriate messages
tw <- "Twitter"
fb <- "Facebook"
wb <- "NESREA Website"
beg <- "Starting %s downloads\n"
end <- "downloads completed\n\n"

## Twitter
cat(sprintf(beg, tw))

source(find_root_file(
  tolower(tw),
  "download-nesrea-tweets.R",
  criterion = rootCrit))

cat(tw, end)

## Facebook
cat(sprintf(beg, fb))

source(find_root_file(
  tolower(fb),
  "download-nesrea-fbposts.R",
  criterion = rootCrit))

cat(fb, end)

## Website
cat(sprintf(beg, wb))

source(find_root_file(
  tolower(strsplit(wb, " ")[[1]][2]),
  "download-nesrea-website.R",
  criterion = rootCrit
))

cat(wb, end)

## cleanup
rm(tw, fb, wb, beg, end)
