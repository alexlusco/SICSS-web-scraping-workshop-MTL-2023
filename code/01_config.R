packages <- c(
  "rvest", "httr", "dplyr", "tibble", "glue", "readr", "tidyr",
  "lubridate", "httr", "janitor", "purrr"
)

for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
  library(package, character.only = TRUE)
}
