# NESREA_social

Easy social media reporting for [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## Prerequisites
Please download and install the following software to get the most out of this project:
* __Rtools__: <https://cran.r-project.org/bin/windows/Rtools/>
* __pandoc__: <http://pandoc.org/installing.html>

## Quick start
1. Generating a report is **super easy**. On the command line, navigate to **this** directory and run  
`Rscript build-report.R`  
This will:
+ build a Microsoft Word (.docx) document
+ assign a filename in the format `weekly-report_YYYY-MM-DD.docx` e.g. *weekly-report-2017-10-01*
+ create a `Reports/` sub-folder, if it does not already exist
+ save the report in the `Reports/` folder

2. The data are stored in a local SQLite database `data/nesreanigeria.db`. SQLite itself is automatically installed with package dependencies. To update the database, the user should run  
`Rscript download-data.R`  

To access all of the other features that are available in this project open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE.

***
Direct enquiries to <socialmedia@nesrea.gov.ng>.
