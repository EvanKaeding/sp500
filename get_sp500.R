## Libraries

library(httr)
library(lubridate)
library(XML)

## 1. Download the page and parse it

        url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

        html <- GET(url)

        contents <- content(html, as = "text")

        parsedHTML <- htmlParse(contents, asText = TRUE)

## 2. Use the readHTMLTable function to exctract only the first table as a data.frame

        sp500 <- readHTMLTable(parsedHTML, which = 1)
        
## 3. Clean up the data. We'll start by cleaning the headers, then reclass some of the variables
        
        colnames(sp500) <- tolower(gsub(" ", "_", colnames(sp500)))
        
        sp500 <- sp500 %>%
                select(-sec_filings) %>%
                mutate(security = as.character(security)) %>%
                mutate(address_of_headquarters = as.character(address_of_headquarters)) %>%
                mutate(date_first_added = ymd(date_first_added))
        
## 4. Finally, we'll save it as something that's easy to read in with its associated metadata
        
        save(sp500, file = "sp500.rda")
        
        
# to load SP500 as a DF into your global environment, do this:
# load("path/SP500.rda")
        
# Resources:
        # Web scaping tutorial: http://bradleyboehmke.github.io/2015/12/scraping-html-tables.html
