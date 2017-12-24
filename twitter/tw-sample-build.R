## tw-sample-build.R
## Script for automated build of sample document

rmarkdown::render("twitter-general.Rmd", output_format = "word_document")
