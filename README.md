# NESREA_social

Easy social media reporting for [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## System requirements
Please download and install the following software to get the most out of this project:
* Rtools: <https://cran.r-project.org/bin/windows/Rtools/>
* pandoc: <http://pandoc.org/installing.html>

## Quick start
1. Creating a report in MS Word is **super easy**. On the command line, navigate to **this** directory and run  
`Rscript build-report.R`  
This will:
+ produce a document that is placed in the `Reports/` folder
+ assign a filename after the pattern `weekly-report_YYYY-MM-DD.docx`
+ create the `Reports/` folder, if it does not exist already

2. The data are stored in a local SQLite database `data/nesreanigeria.db`. SQLite is automatically installed with package dependencies. To update the database, the user should run  
`Rscript download-data.R`  

To access all of the other features available in this project open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE.

***
Direct enquiries to <socialmedia@nesrea.gov.ng>.
