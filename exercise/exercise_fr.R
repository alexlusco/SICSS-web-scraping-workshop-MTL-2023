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
# 1. Trouver une URL
#-------------------------------------------------------

url <- ""

#-------------------------------------------------------
# 2. Inspecter le fichier robots.txt et les conditions générales
#-------------------------------------------------------

# La page web possède-t-elle un fichier /robots.txt ? Si oui, vous interdit-il de scraper les informations souhaitées ?
# Quelles autres exigences le fichier /robots.txt fournit-il (par exemple, crawl-delay) qui pourraient avoir un impact sur notre scraper ?

#-------------------------------------------------------
# 3. Analyser le DOM
#-------------------------------------------------------

parsed_html <- read_html(url)

#-------------------------------------------------------
# 4. Identifier, tester et valider les sélecteurs CSS / XPaths
#-------------------------------------------------------

# Pour identifier les sélecteurs CSS et les XPaths, utilisez le mode développeur du navigateur ou SelectorGadget (une extension de navigateur)
# https://selectorgadget.com/

parsed_html |> 
  ...

#-------------------------------------------------------
# 5. Écrire le contenu extrait dans un tableau
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
# 5. Erreurs, limitations, biais
#-------------------------------------------------------

# Quelles difficultés avez-vous rencontrées lors de cette extraction ? Quels messages d'erreur avez-vous reçus ?
# Des préoccupations concernant les limitations et les biais dans les données ?

