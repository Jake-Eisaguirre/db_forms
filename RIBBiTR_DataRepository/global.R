
# if (!require(librarian)){
#   install.packages("librarian")
#   library(librarian)
# }
# 
# # librarian downloads, if not already downloaded, and reads in needed packages
# 
# librarian::shelf(shiny, tidyverse, here, janitor, lubridate, RPostgres, rstudioapi, shinyWidgets, 
#                  DT, glue, shinycssloaders, DBI, gargle,
#                  shinyalert, googledrive, shinylogs, cachem, shinymanager)


library(tidyverse)
library(here)
library(janitor)
library(lubridate)
library(RPostgres)
library(rstudioapi)
library(shinyWidgets)
library(DT)
library(glue)
library(shinycssloaders)
library(DBI)
library(gargle)
library(shinyalert)
library(googledrive)
library(shinylogs)
library(cachem)
library(shinymanager)



# options(gargle_oob_default = TRUE)
# 
# drive_auth(cache = ".secrets", email = T)
# 
# # designate project-specific cache
# options(gargle_oauth_cache = ".secrets")
# 
# # check the value of the option, if you like
# gargle::gargle_oauth_cache()
# 
# # trigger auth on purpose --> store a token in the specified cache
# drive_auth()
# 
# # see your token file in the cache, if you like
# list.files(".secrets/")


shinyOptions(cache = cachem::cache_disk("./app_cache"))
#shinyOptions(cache = cachem::cache_mem(max_size = 1000e6))


# slow method for reading in all csv files

# loop not working for read in maybe
# filenames <- gsub("\\.csv$","", list.files(here("RIBBiTR_DataRepository/data")))
# 
# for(i in filenames){
#   assign(i, read_csv(here("RIBBiTR_DataRepository/data", paste(i, ".csv", sep=""))))
# }

visit <- read_csv(here("data/visit.csv"))

ves <- read_csv(here("data/ves.csv"))

ves_cols <- read_csv(here("data/ves_cols.csv"))

survey <- read_csv(here("data/survey.csv"))

site <- read_csv(here("data/site.csv"))

serdp_muc_mic <- read_csv(here("data/serdp_muc_mic.csv"))

serdp_bd_genom <- read_csv(here("data/serdp_bd_genom.csv"))

serdp_amp <- read_csv(here("data/serdp_amp.csv"))

region <- read_csv(here("data/region.csv"))

location <- read_csv(here("data/location.csv"))

hobo <- read_csv(here("data/hobo.csv"))

hobo_site <- read_csv(here("data/hobo_site.csv"))

hobo_region <- read_csv(here("data/hobo_region.csv"))

hobo_location <- read_csv(here("data/hobo_location.csv"))

hobo_cols <- read_csv(here("data/hobo_cols.csv"))

comb_bd <- read_csv(here("data/comb_bd.csv"))

capture <- read_csv(here("data/capture.csv"))

aural <- read_csv(here("data/aural.csv"))

cap <- read_csv(here("data/cap.csv"))

aural_cols <- read_csv(here("data/aural_cols.csv"))



#### Login ######
inactivity <- "function idleTimer() {
var t = setTimeout(logout, 120000);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout() {
window.close();  //close the window
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();"
