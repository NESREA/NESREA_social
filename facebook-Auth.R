# Load package
library(Rfacebook)
# Open the Facebook Developer site and obtain the temporary access token
BROWSE(url = "https://developers.facebook.com/tools/explorer/")

access_token <- ""
user <- getPage("https://www.facebook.com/NESREANigeria", token = access_token)
getPage
