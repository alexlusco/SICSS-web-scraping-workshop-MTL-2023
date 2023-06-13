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

# source("code/01_config.R")

#-------------------------------------------------------
# Scrape 1 - single page
#-------------------------------------------------------

# (1) define URL of website we want to scrape
url <- "https://sicss.io/locations"

# (2) parse HTML
parsed_html <- read_html(url)

# (4) scrape the parsed html, here we extract the location and the date for each node of
# the .card-title and .card-text classes

location <- parsed_html |>
  html_nodes(".card-title") |>
  html_text()

date <- parsed_html |>
  html_nodes(".card-text") |>
  html_text()

# (4) save results to a table that can be analyzed / written to our local machines
results <- tibble(
  title = location,
  date = date,
  source = url
)

results

write_csv(results, "data/scrape_1_results.csv")

#-------------------------------------------------------
# Scrape 2 - multiple pages
#-------------------------------------------------------

# (1) define URL of website we want to scrape
url <- "https://sicss.io/locations"

parsed_html <- read_html(url)

# (4) scrape the parsed html
location <- parsed_html |>
  html_nodes(".card-title") |>
  html_text()

date <- parsed_html |>
  html_nodes(".card-text") |>
  html_text()

learn_more_source <- parsed_html |>
  html_nodes(".card-text+ .btn-sm") |>
  html_attr("href") |>
  url_absolute(url)

# (4) save results to a table
results <- tibble(
  location = location,
  date = date,
  learn_more_source = learn_more_source,
  main_source = url
)

results

# (5) parse and scrape content from each of the URLs in learn_more_source and
# add to previous data table

output <- list() # create empty list to save outputs in for loop

sleep <- 3 # set crawl-delay to 3 seconds

for (r in 1:nrow(results)) {
  url <- results[r, ]$learn_more_source

  parsed_html <- read_html(url)

  cat(glue::glue("Scraping contents of {url}... \n\n"))

  p_content <- parsed_html |>
    html_node(".mb-5") |>
    html_text(trim = TRUE)

  curr_data <- tibble(
    location = results[r, ]$location,
    date = results[r, ]$date,
    learn_more = p_content,
    learn_more_source = results[r, ]$learn_more_source,
    main_source = results[r, ]$main_source
  )

  output[[r]] <- curr_data

  cat(glue("Pausing for {sleep} seconds... \n\n"))

  Sys.sleep(sleep)
}

results <- bind_rows(output)

results

write_csv(results, "data/scrape_2_results.csv")

#-------------------------------------------------------
# Scrape 3 - multiple pages continued
#-------------------------------------------------------

scrape_2_results <- read_csv("data/scrape_2_results.csv")

scrape_2_results <- scrape_2_results |>
  mutate(people_source = paste0(learn_more_source, "/people"))

scrape_3_results <- scrape_2_results |>
  mutate(n_people = purrr::map(row_number(), ~ {
    r <- .

    url <- scrape_2_results[r, ]$people_source

    parsed_html <- read_html(url)

    cat(glue("Scraping contents of {url}...\n\n"))

    n_people <- parsed_html |>
      html_nodes(".mt-0") |>
      html_text() |>
      length()

    cat(glue("Pausing for {sleep} seconds...\n\n"))

    Sys.sleep(sleep)

    n_people
  })) |>
  unnest(n_people)

scrape_3_results

write_csv(scrape_3_results, "data/scrape_3_results.csv")

#-------------------------------------------------------
# Scrape 4 - file downloads
#-------------------------------------------------------

scrape_3_results <- read_csv("data/scrape_3_results.csv")

# get URLs to src assets

scrape_4_results <- scrape_3_results |>
  mutate(src_source = map(row_number(), ~ {
    r <- .

    url <- scrape_2_results[r, ]$learn_more_source

    parsed_html <- read_html(url)

    cat(glue("Scraping contents of {url}...\n\n"))

    src_source <- parsed_html |>
      html_node(".mb-3") |>
      html_attr("src") |>
      url_absolute(url)

    cat(glue("Pausing for {sleep} seconds...\n\n"))

    Sys.sleep(sleep)

    src_source
  })) |>
  unnest(src_source)

write_csv(scrape_4_results, "data/scrape_4_results.csv")

# download each jpg using the respective URL, save to local machine

for (r in 1:nrow(scrape_4_results)) {
  filename <- paste0(scrape_4_results[r, ]$location, ".jpg")

  filepath <- file.path("data/images", filename)

  tryCatch(
    {
      GET(scrape_4_results[r, ]$src_source, write_disk(filepath, overwrite = TRUE))
      cat(glue("Image {filename} downloaded successfully.\n\n"))
    },
    error = function(e) {
      cat(glue("Error downloading {scrape_4_results[r, ]$src_source} : {conditionMessage(e)} \n\n"))
      write_csv(tibble(scrape_4_results[r, ]$src_source), "data/images/failed_log.csv", append = TRUE)
    }
  )
}

#-------------------------------------------------------
# More tips and techniques:
# user-agent and header customization, saving as we go,
# time stamps, random Sys.sleep(), status checks
#-------------------------------------------------------

scrape_2_results <- read_csv("data/scrape_2_results.csv") |>
  sample_n(size = 15) # for demonstration purposes, we'll take a random sample of 15

# create blank file with colnames to populate with output of scrape, alternative to output <- list()

output_file <- tibble(
  location = NA,
  date = NA,
  learn_more = NA,
  learn_more_source = NA,
  main_source = NA,
  timestamp = NA
)

write_csv(output_file |> drop_na(), "data/appended_scrape_results.csv")

for (i in 1:nrow(scrape_2_results)) {
  url <- scrape_2_results[i, ]$learn_more_source
  
  # customize user-agent and header information
  headers <- c("Custom-Header1" = "Value1", "Custom-Header2" = "Value2")
  user_agent <- "Your User Agent"
  
  # send GET request with customized user-agent and headers
  response <- GET(
    url,
    user_agent(user_agent),
    add_headers(.headers = headers)
  )
  
  # check if the response status code is not 404
  if (status_code(response) != 404) {
    parsed_html <- read_html(response)
    
    cat(glue("Scraping contents of {url}...\n\n"))
    
    # Extract the desired content using appropriate CSS selector
    p_content <- parsed_html %>%
      html_node(".mb-5") %>%
      html_text(trim = TRUE)
    
    # create a tibble with scraped data, including timestamp
    curr_data <- tibble(
      location = scrape_2_results[i, ]$location,
      date = scrape_2_results[i, ]$date,
      learn_more = p_content,
      learn_more_source = scrape_2_results[i, ]$learn_more_source,
      main_source = scrape_2_results[i, ]$main_source,
      scrape_timestamp = now()
    )
    
    # append the data to a CSV file
    write_csv(curr_data, "data/appended_scrape_results.csv", append = TRUE)
    
    # randomize crawl-delay by sleeping for a random duration
    random_sleep <- sample(1:3, 1)
    
    cat(glue("Pausing for {random_sleep} seconds...\n\n"))
    
    Sys.sleep(random_sleep)
  } else {
    cat(glue("Skipping {url} as it returned a 404 error.\n\n"))
  }
}

