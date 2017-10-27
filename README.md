# NESREA_social

This project is focused on the development of social media reports carried out by [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## Quick tips
Please note these instructions:

1. Creating a report in MS Word is **super easy**. On the command line, navigate to **this** directory and run  
`Rscript build-report.R`  
This will produce a document that is placed in the `Reports` folder, and which has a filename that contains the date the report was generated, after the pattern `weekly-report_YYYY-MM-DD.docx`. If `Reports` does not exist on your computer, it will be automatically created.

2. The tweets are stored in a local SQLite database `data/nesreanigeria.db`, which may likely be outdated at the time the report is being generated. To update it, the user should run  
`Rscript download-nesrea-tweets.R`  

*System requirements:* To easily build these documents in the Windows command line, you will need to have [Rtools](https://cran.r-project.org/bin/windows/Rtools/) and [pandoc](http://pandoc.org/installing.html) installed.

To access all of the other features available in this project (in addition to the aforementioned) open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE.


