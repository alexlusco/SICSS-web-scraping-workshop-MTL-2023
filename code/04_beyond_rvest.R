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

#################################### Workshop content starts below ####################################

#-------------------------------------------------------
# When rvest is not enough
#-------------------------------------------------------

# rvest, a powerful web scraping package in R, excels at extracting data from static HTML content. However, it 
# encounters limitations when dealing with dynamic content that is not readily available in the HTML source.

# Dynamic content refers to elements that are generated or modified by JavaScript or other client-side scripts 
# after the initial page load.

# To overcome these limitations, there are several strategies that can be employed:

#-------------------------------------------------------
# 1. Locating a client-side API
#-------------------------------------------------------

# Many websites use client-side APIs to fetch data dynamically. By inspecting the network requests made by the website 
# using the browser's developer tools, you can identify these APIs and the corresponding endpoints. Once identified, you
# can make direct requests to the API endpoints using packages like `httr` or `jsonlite` to retrieve the desired data.

# example:
"https://sicss.io/assets/json/all-people-index.json"

library(httr)
library(jsonlite)
library(tidyjson) 
library(listviewer)

#-------------------------------------------------------
# 2. Accessing a server-side API
#-------------------------------------------------------

# Some websites have official APIs that provide structured and up-to-date data. These APIs often require authentication 
# or an API key. By obtaining access to the server-side API, you can retrieve the dynamic content directly in a structured 
# format without the need for scraping. Many users create public R libraries that make it easy to get and parse data from
# a server-side API using our authentication keys.

#-------------------------------------------------------
# 3. Remote browser scraping
#-------------------------------------------------------

# 3. RSelenium is an R package that allows you to automate a web browser. It enables you to interact with websites, 
# including handling dynamic content. By launching a browser instance with RSelenium, you can navigate through pages, 
# interact with elements, and retrieve dynamically generated data.

library(RSelenium)
