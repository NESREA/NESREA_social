## fb-sample-build.R
## Script for automated build of sample document

rmarkdown::render("facebook-general.Rmd", output_format = "word_document")
