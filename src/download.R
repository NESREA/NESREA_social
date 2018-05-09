# download.R

## Download data from the NESEREA web and social media platforms

## Dependency assurance
if (!("webreport" %in% .packages(all.available = TRUE))) {
  cat("attempt to install dependencies\n")
  if (!requireNamespace("devtools")) {
    cat("Attempting to download 'devtools' from R Studio's CRAN mirror:\n")
    install.packages("devtools", repos = "https://cran.rstudio.com")
  }
  devtools::install_github("NESREA/webreport")
}

webreport::download_all_data("nesreanigeria", "data/nesreanigeria.db")
