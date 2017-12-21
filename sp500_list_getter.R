## SP500 List maker

## This script reads data from a table on Wikipedia containing information about the
## top 500 companies by revenue in the world, cleans it and outputs it into a data.frame.

## NOTE: This version is depricated. Please use get_sp500.R instead.

## Libraries

library(httr)
library(XML)

## Download the page and parse it

url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

html <- GET(url)

contents <- content(html, as = "text")
parsedHTML <- htmlParse(contents, asText = TRUE)

## Start grabbing stuff

headers <- xpathSApply(parsedHTML, "//th", xmlValue)
body <- xpathSApply(parsedHTML, "//td", xmlValue)

## Clean it up

# clean up headers by truncating it, making lower case and adding subbing in underscores for spaces

headers <- headers[c(1:8)]
headers <- tolower(headers)
headers <- gsub(" ", "_", headers)

# body: One would expect body to contain 500 * 8 = 4,000 values. However, it contains 4,995
# Upon further analysis, it appears that body grabbed table rows for all tables, not just the
# SP500 table. The final character in this table is 0001555280, which has an index of 4,040
# indicating that there are 505 observations of 8 variables. This info will be used to inform
# the design of the cleaning script. Future iterations of this script should extract only the
# relevant information from the webpage.

body <- body[c(1:4040)]

# create the data.frame

data <- data.frame(matrix(data = body, nrow = 505, ncol = 8, byrow = TRUE))
colnames(data) <- headers

# correct the variable types

data$ticker_symbol <- as.character(data$ticker_symbol)
data$security <- as.character(data$security)
data <- data[,c(1,2,4:8)] #remove the 'sec_filing' variable
data$address_of_headquarters <- as.character(data$address_of_headquarters)
data$date_first_added <- ymd(as.character(data$date_first_added)) #coerces blanks to NAs
data$cik <- as.character(data$cik)

## Give it a nice name and write it out to preserve the structure

SP500 <- data
save(SP500, file = "SP500.rda")

# to load SP500 as a DF into your global environment, do this:
# load("path/SP500.rda")
