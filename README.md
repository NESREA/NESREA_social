# NESREA_social
Easy social media reporting for [NESREA](http://www.nesrea.gov.ng)'s Web Monitoring Group.

## Usage
To use, download or `git clone` the repository.

## Prerequisites
* __R__: <http://cran.r-project.org>
* __RTools__: <https://cran.r-project.org/bin/windows/Rtools/index.html>
* __pandoc__: <http://pandoc.org/installing.html>
* __Java__: <https://java.com/en/download/manual.jsp>

## Usage  
### On the command line  

**1. Build a report**  
Navigate to the **NESREA_social** directory and simply type  
```
make doc
```

Upon running this command, the following will happen:
+ A Microsoft Word (.docx) document containing the results of the data analysis will be built.
+ A filename in the format `weekly-report_YYYY-MM-DD.docx` will be assigned to the document e.g. *weekly-report-2017-10-01* for a report generated on 1st October 2017.
+ A `Reports/` sub-folder, will be created (if it does not already exist).
+ The report will be saved in the `Reports/` folder.

**2. Download new data**  
The data are stored in a local **SQLite** database, called `nesreanigeria.db`; SQLite itself is automatically installed alongside relevant CRAN packages. To optionally update the database before generating the report, the user should type
```
make update
```

**3. Conduct tests**  
This project is intended to be high-flux, with frequent updates, as well as to provide a measure of instruction for NESREA's  Web Monitoring Group. Should the user want to be part of its development or wishes to clone it for a different line of development, testing capabilities have been included. To easily run a unit test in the project, simply type
```
make test
```

For additional features (e.g. experimental files, tutorials), open `NESREA_social.Rproj` in the [RStudio](https://www.rstudio.com/products/RStudio/) IDE and explore the various directories, especially in  *facebook*, *twitter* and *website*.

__*Note that due to the absence of a graphics device (at the time of writing), this document cannot be built in the Linux Subsystem for Windows 10.*__  
***
Contact: <socialmedia@nesrea.gov.ng>.
