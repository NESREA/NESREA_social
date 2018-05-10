## MAKEFILE ##
# Generate a document report from .Rmd file

R_AUTO=Rscript
RSFLAGS=--vanilla

all: update doc


update:
	$(R_AUTO) $(RSFLAGS) data/download.R

test:
	$(R_AUTO) $(RSFLAGS) tests/testthat.R

facebook:
	$(R_AUTO) $(RSFLAGS) docs/facebook-general.Rmd

twitter:
	$(R_AUTO) $(RSFLAGS) docs/twitter-general.Rmd
	
website:
	$(R_AUTO) $(RSFLAGS) docs/website.Rmd
