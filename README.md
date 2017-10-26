# NESREA_social

This project is focused on the development of social media reports carried out by [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## Quick tips

1. Creating a report in MS Word is **super easy**. On the command line, navigate to **this** directory and run  
`Rscript build-report.R`  
This will produce a document that is placed in the `Reports` folder, and which has a filename that contains the date the report was generated, after the pattern `weekly-report_YYYY-MM-DD.docx`.

2. The tweets are stored in a local SQLite database `data/nesreanigeria.db`, which may likely be outdated at the time the report is being generated. To update it, the user should run  
`Rscript download-nesrea-tweets.R`  

To access all of the available features in this project, in addition to the above, open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE.
