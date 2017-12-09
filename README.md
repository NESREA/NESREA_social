# NESREA_social
Easy social media reporting for [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## Usage
To use, download or `git clone` the repository.

## Prerequisites
* __R__: <http://cran.r-project.org>
* __pandoc__: <http://pandoc.org/installing.html>

## Usage  
Generating a report is **super easy**. On the command line, navigate to **this** directory and simply run  
```
smReports
```

This will:
+ build a Microsoft Word (.docx) document
+ assign a filename in the format `weekly-report_YYYY-MM-DD.docx` e.g. *weekly-report-2017-10-01*
+ create a `Reports/` sub-folder, if it does not already exist
+ save the report in the `Reports/` folder
  
The data are stored in a local **SQLite** database, `data/nesreanigeria.db`; SQLite itself is automatically installed. To optionally update this database before generating the report, the user should add an argument to the command:
```
smReports --update
```

To access all of the other features that are available in this project open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE.

***
Contact: <socialmedia@nesrea.gov.ng>.
