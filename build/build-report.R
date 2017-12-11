# Knit, save and display report as MS Word document

## Some housekeeping:
## Set up things as far as directory trees are concerned.
## This includes making sure we are working in the right place per time.
## Also make sure we have a folder in place for saving reports.
repoName <- "NESREA_social"
currDir <- getwd()
if (identical(basename(currDir), repoName)) {
  rootDir <- currDir
} else if (!grepl(repoName, currDir, ignore.case = TRUE)) {
  stop("You are not on the desired file path.")
} else {
  rootDir <- substr(currDir,
                    start = 0,
                    stop = regexpr(repoName, currDir) + nchar(repoName))
  setwd(rootDir)
}
rm(currDir, repoName)

buildDir <- file.path(rootDir, "build/")
dataDir <- file.path(rootDir, "data/")

setwd(buildDir)
filename <- paste0("weekly-report_", Sys.Date(), ".docx")
folder <- file.path(rootDir, "Reports")
folderlist <- list.dirs(rootDir, recursive = FALSE, full.names = FALSE)

if (as.character(folder) %in% folderlist)
  dir.create(folder)

## Prompt the user to optionally download fresh data
if (interactive()) {
  switch(
    menu(choices = c("Yes", "No"),
         title = "Would you like to download data? (May take some time!)"),
    source(file.path(rootDir, "data/download-data.R")),
    cat("Update of database was skipped\n")
  )
}

## The main job
cat("Building the document\n")
if (!requireNamespace("rmarkdown"))
  install.packages("rmarkdown", repos = "https://cran.rstudio.com")
rmarkdown::render(
  file.path(buildDir, "report-template.Rmd"),
  output_format = "word_document",
  output_file = filename,
  output_dir = folder
)

try(
  system(paste("open", file.path(folder, filename)))
)
rm(filename, folder, folderlist, rootDir, buildDir)
