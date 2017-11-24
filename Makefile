## MAKEFILE ##
# Generate a document report from .Rmd file

R_AUTO = Rscript.exe
RSFLAGS = --vanilla

all:  
	$(R_AUTO) $(RSFLAGS) build-report.R
	
update:
	$(R_AUTO) $(RSFLAGS) download-data.R
