# Knit, save and display report as MS Word document

filename <- paste0("weekly-report_", Sys.Date(), ".docx")
folder <- "Reports"
folderlist <- list.dirs(recursive = FALSE, full.names = FALSE)

if (!any(grepl(as.character(folder), folderlist)))
  dir.create(folder)

if (interactive()) {
  switch(
    menu(choices = c("Yes", "No"),
         title = "Would you like to download data? (May take some time!)"),
    source("download-data.R"),
    cat("Update of database was skipped\n")
  )
}

rmarkdown::render(
  "weekly-report-generic.Rmd",
  output_format = "word_document",
  output_file = filename,
  output_dir = folder
)

system(paste("open", file.path(folder, filename)))
