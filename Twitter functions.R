collect.tweets <- function(string = character())
{
  twt <- NULL
  if (!is.character(string))
    stop("'string' is not a character vector")
  if (nchar(string) < 3)
    stop("A term of less than 3 characters was chosen")
  else if (nchar(string) > 70)
    stop("A term longer than 70 characters was chosen")
  else {
    twt <- twitteR::searchTwitter(string, n = 1000)
    twt <- twitteR::twListToDF(twt)
  }
  twt
}

density.display <- function(data)
{
  if (!require(ggplot2)) {
    message("package:ggplot2 is missing")
    Sys.sleep(3)
    message("R will now download and install required package(s).\n
            On completion, run 'density.display()' again.")
    install.packages("ggplot2")
  }
  if (!is.data.frame(data))
    stop("data is not a data frame")
  plot <- ggplot(data, aes(created)) +
    geom_density(aes(fill = isRetweet), alpha = 0.7) +
    theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
    xlab("All tweets")
  print(plot)
}