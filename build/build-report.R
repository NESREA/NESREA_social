# Knit, save and display report as MS Word document

## Some housekeeping:
## Set up things as far as directory trees are concerned.
## This includes making sure we are working in the right place per time.
## Also make sure we have a folder in place for saving reports.
pkgs <- c("rmarkdown", "rprojroot")

lapply(pkgs, function(P) {
  if (!require(P, character.only = TRUE, quietly = TRUE)) {
    install.packages(P, repos = "http://cran.rstudio.com")
  }
  if (pkgs %in% .packages(all.available = TRUE)) {
    library(rmarkdown)
    library(rprojroot)
  }
})

rootDir <- rprojroot::find_root(has_file("NESREA_social.Rproj"))
filename <- paste0("weekly-report_", Sys.Date(), ".docx")
folder <- file.path(rootDir, "Reports")
folderlist <- list.dirs(rootDir, recursive = FALSE, full.names = FALSE)

if (!basename(folder) %in% folderlist)
  dir.create(folder)

## Prompt the user to optionally download fresh data
if (interactive()) {
  switch(
    menu(choices = c("Yes", "No"),
         title = "Would you like to download data? (May take some time)"),
    source(file.path(rootDir, "data/download-data.R")),
    cat("Database update was skipped\n")
  )
}

## The main job
cat("Building the document\n")

rmarkdown::render(
  find_root_file("build", "report-template.Rmd",
                 criterion = has_file("NESREA_social.Rproj")),
  output_format = "word_document",
  output_file = filename,
  output_dir = folder
)

try(
  system(paste("open", file.path(folder, filename)))
)
rm(filename, folder, folderlist, rootDir, buildDir)
