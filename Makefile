## MAKEFILE ##
# Generate a document report from .Rmd file

R_AUTO = Rscript
RSFLAGS = --vanilla

all:  
	$(R_AUTO) $(RSFLAGS) build/build-report.R
	
update:
	$(R_AUTO) $(RSFLAGS) data/download-data.R

test:
	$(R_AUTO) $(RSFLAGS) tests/testthat.R
