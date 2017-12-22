## MAKEFILE ##
# Generate a document report from .Rmd file

R_AUTO=Rscript
RSFLAGS=--vanilla

all: update doc

doc: build/build-report.R
	$(R_AUTO) $(RSFLAGS) build/build-report.R
	
update: data/download-data.R
	$(R_AUTO) $(RSFLAGS) data/download-data.R

test:
	$(R_AUTO) $(RSFLAGS) tests/testthat.R
