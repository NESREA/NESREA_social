# Knit, save and display report as MS Word document
rootDir <- getwd()
setwd(file.path(rootDir, "build/"))

filename <- paste0("weekly-report_", Sys.Date(), ".docx")
folder <- file.path(getwd(), "Reports")
folderlist <- list.dirs(rootDir, recursive = FALSE, full.names = FALSE)

if (as.character(folder) %in% folderlist)
  dir.create(folder)

if (interactive()) {
  switch(
    menu(choices = c("Yes", "No"),
         title = "Would you like to download data? (May take some time!)"),
    source("../data/download-data.R"),
    cat("Update of database was skipped\n")
  )
}

rmarkdown::render(
  file.path(getwd(), "weekly-report-generic.Rmd"),
  output_format = "word_document",
  output_file = filename,
  output_dir = folder
)

system(paste("open", file.path(folder, filename)))

rm(filename, folder, folderlist)
