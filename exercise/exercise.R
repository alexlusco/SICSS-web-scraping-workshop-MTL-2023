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
# The author and the SICSS UQAM organizers hold no responsibility for any misuse or unlawful activities 
# conducted using the techniques presented in this workshop. Participants are solely responsible for complying 
# with applicable laws, terms of service, and ethical guidelines when conducting web scraping activities.

#################################### Workshop content starts below ####################################

#-------------------------------------------------------
# 1. locate a URL
#-------------------------------------------------------

url <- ""

#-------------------------------------------------------
# 2. Inspect robots.txt and terms and conditions
#-------------------------------------------------------

# Does the webpage have a /robots.txt? If yes, does it disallow you from scraping information you wanted?
# What other requirements does the /robots.txt provide (e.g., crawl-delay) that might impact our scraper?

#-------------------------------------------------------
# 3. Parse the DOM
#-------------------------------------------------------

parsed_html <- read_html(url)

#-------------------------------------------------------
# 4. Identify, test, and validate CSS selectors / XPaths
#-------------------------------------------------------

# to identify CSS selectors and XPaths, use either developer mode in browser or SelectorGadget (browser add on)
# https://selectorgadget.com/

parsed_html |> 
  ...

#-------------------------------------------------------
# 5. Write scraped contents to a table
#-------------------------------------------------------

content1 <- parsed_html |> 
  ...

content2 <- parsed_html |> 
  ...

content3 <- parsed_html |> 
  ...

df <- tibble(
  content1 = content1,
  content2 = content2,
  content3 = content3
)

#-------------------------------------------------------
# 5. Errors, limitations, biases
#-------------------------------------------------------

# What difficulties did you encounter doing this scrape? What error messages did you receive?
# Concerns about limitations and baises in the data?
