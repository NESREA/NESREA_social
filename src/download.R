# download.R

## Download data from the NESEREA web and social media platforms

## Dependency assurance
# pause <- function() Sys.sleep(1)
# wr <- "webreport"
# if (!require(wr)) {
#   cat("Install", wr, "...")
#   if (!requireNamespace("devtools")) {
#     install.packages("devtools", repos = "https://cran.rstudio.com")
#     pause()
#   }
#   devtools::install_github("NESREA/webreport")
#   pause()
#   if (wr %in% .packages(all.available = TRUE)) {
#     require(wr, quietly = TRUE)
#     cat("Done")
#   } else {
#     cat("FAILED")
#     stop()
#   }
# }

webreport::download_all_data("nesreanigeria", "data/nesreanigeria.db")
