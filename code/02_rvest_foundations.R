# SICSS UQAM 2023 Web Scraping Workshop
#
# Author: Alex Luscombe, June 2023
#
# This R script was created for the SICSS UQAM 2023 workshop on web scraping with rvest. The purpose of
# this workshop is to provide an introduction to web scraping techniques using the rvest package in R.
# Participants will learn how to extract and analyze data from websites, enabling them to collect valuable
# information for research and analysis.
#
# This workshop material is intended solely for educational purposes. The examples, code snippets, and
# techniques demonstrated here are for learning purposes and should not be used for any unauthorized or
# unethical activities. Participants are encouraged to apply the knowledge gained responsibly and within the
# legal and ethical boundaries of web scraping.
#
# The author holds no responsibility for any misuse or unlawful activities conducted using the techniques 
# presented in this workshop. Participants are solely responsible for complying with applicable laws, terms of 
# service, and ethical guidelines when conducting web scraping activities.
#
#################################### Workshop content starts below ####################################

# source("code/01_config.R")

#-------------------------------------------------------
# Defining the url
#-------------------------------------------------------

url <- "https://sicss.io/locations"

#-------------------------------------------------------
# Parsing the DOM
#-------------------------------------------------------

parsed_html <- read_html(url)

parsed_html

#-------------------------------------------------------
# Extracting text
#-------------------------------------------------------

parsed_html |>
  html_node("body") |>
  html_node("p") |>
  html_text()

parsed_html |>
  html_node("body") |>
  html_nodes("p") |>
  html_text()

#-------------------------------------------------------
# Extracting links
#-------------------------------------------------------

parsed_html |>
  html_nodes("body a") |>
  html_attr("href")

parsed_html |>
  html_nodes("body a") |>
  html_attr("href") |>
  url_absolute(url)

#-------------------------------------------------------
# Extracting images
#-------------------------------------------------------

parsed_html |>
  html_nodes(".card-img-top") |>
  html_attr("src") |>
  url_absolute(url)

#-------------------------------------------------------
# Extracting tables
#-------------------------------------------------------

url <- "https://en.wikipedia.org/wiki/List_of_Stanley_Cup_champions"

parsed_html <- read_html(url)

parsed_html |>
  html_node(xpath = '//*[@id="mw-content-text"]/div[1]/table[5]') |>
  html_table()

#-------------------------------------------------------
# Extracting content from multiple URLs (for loops)
#-------------------------------------------------------

# test and validate selectors, inspect output

url <- paste0("https://research.un.org/en/docs/ga/quick/regular/55")

parsed_html <- read_html(url)

table <- parsed_html |>
  html_node(".tablefont") |>
  html_table()

table |>
  janitor::row_to_names(row_number = 1) |>
  select(1:6)

# write for loop on 20 years of sessions (2000-2020)

urls <- paste0("https://research.un.org/en/docs/ga/quick/regular/", 55:75)

output <- list()

for (u in urls) {
  parsed_html <- read_html(u)

  print(paste("Scraping contents of", u))

  table <- parsed_html |>
    html_node(".tablefont") |>
    html_table() |>
    janitor::row_to_names(row_number = 1) |>
    select(1:6)

  output[[u]] <- table

  Sys.sleep(3) # crawl-delay of 3 seconds
}

resolution_tables <- bind_rows(output)

resolution_tables
