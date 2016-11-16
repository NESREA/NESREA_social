# facebook-Auth.R
# API access for the 'NESREA' Facebook app

app_id <- "203440573439361"
app_secret <- "c3b0eecbe6bfeb465438a68e8205c67b"

NESREA_fb_oauth <- Rfacebook::fbOAuth(app_id = app_id, app_secret = app_secret)
save(NESREA_fb_oauth, file = "NESREA_fb_oauth")

# To use, run: load("NESREA_fb_oauth")