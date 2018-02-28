## download-nesrea-tweets.R
## Update NESREA database

ensure_packages("twitteR")
source(find_root_file("twitter", "tw-functions.R", criterion = rootCrit))

logon_to_twitter()
update_nesrea_db()
