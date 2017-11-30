# Knit, save and display report as MS Word document
repoName <- "NESREA_social"
if (identical(basename(getwd()), repoName)) {
  rootDir <- getwd()
} else {
  currDir <- getwd()
  rootDir <- substr(currDir,
                    start = 0,
                    stop = regexpr(repoName, currDir) + nchar(repoName))
  setwd(rootDir)
  rm(currDir)
}
buildDir <- file.path(rootDir, "build/")
dataDir <- file.path(rootDir, "data/")

setwd(buildDir)
filename <- paste0("weekly-report_", Sys.Date(), ".docx")
folder <- file.path(rootDir, "Reports")
folderlist <- list.dirs(rootDir, recursive = FALSE, full.names = FALSE)

if (as.character(folder) %in% folderlist)
  dir.create(folder)

if (interactive()) {
  switch(
    menu(choices = c("Yes", "No"),
         title = "Would you like to download data? (May take some time!)"),
    source(file.path(rootDir, "data/download-data.R")),
    cat("Update of database was skipped\n")
  )
}

if (!requireNamespace("rmarkdown")) install.packages("rmarkdown")
rmarkdown::render(
  file.path(buildDir, "report-template.Rmd"),
  output_format = "word_document",
  output_file = filename,
  output_dir = folder
)

system(paste("open", file.path(folder, filename)))

rm(filename, folder, folderlist, rootDir, buildDir)
