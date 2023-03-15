
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
library(lubridate) # new
library(RPostgres) # new
#library(rstudioapi)
library(shinyWidgets)
library(DT)
#library(glue)
library(shinycssloaders)
library(DBI) # new
library(gargle)
library(shinyalert)
library(googledrive)
library(shinylogs)
library(cachem)
library(shinymanager)
library(dbplyr) # new


shinyOptions(cache = cachem::cache_disk("./app_cache"))
#shinyOptions(cache = cachem::cache_mem(max_size = 1000e6))

# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  connection <- dbConnect(drv, 
                          dbname = Sys.getenv("aws_dbname"),
                          host = Sys.getenv("aws_host"), 
                          port = Sys.getenv("aws_port"),
                          user = Sys.getenv("aws_user"), 
                          password = Sys.getenv("aws_password"))
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})


########## survey_data ##########

######### survey_data #########

dbExecute(connection, "set search_path = survey_data")

# # location
# location <- dbGetQuery(connection, "select location from location;") %>%
#   drop_na()
# 
# # region
# region <- dbGetQuery(connection, "select region from region;") %>%
#   drop_na()
# 
# # site list
# site_list <- dbGetQuery(connection, "select site from site") %>%
#   drop_na()

# # site
# site <- dbGetQuery(connection, "select * from site") %>%
#   select(!c(site_id, region_id)) %>%
#   colnames() %>% as.data.frame()

# years slider
years <- dbGetQuery(connection, "select date from visit") %>% 
  mutate(year = year(date)) %>% 
  filter(!duplicated(year)) %>% 
  select(!c(date)) %>% 
  drop_na()

# # visit
# visit <- dbGetQuery(connection, "select * from visit") %>% 
#   select(!c(visit_id, site_id)) %>% 
#   colnames() %>%  data.frame()
# 
# # survey
# survey <- dbGetQuery(connection, "select * from survey")
# survey <- select(survey, !c(visit_id, survey_id)) %>% 
#   colnames() %>% as.data.frame()
# 
# # capture
# capture <- dbGetQuery(connection, "select * from capture") 
# capture <- select(capture, !c(survey_id, capture_id)) %>% 
#   colnames() %>% as.data.frame()

# BD #

comb_bd <-  dbGetQuery(connection, "select * from temp_shiny_bd") %>% 
  colnames() %>% as.data.frame()

# AMP #
serdp_amp <- dbGetQuery(connection, "select * from serdp_amp")%>% 
  colnames() %>% as.data.frame()

# Muc/microbiome #
serdp_muc_mic <- dbGetQuery(connection, "select * from serdp_newt_microbiome_mucosome_antifungal") %>% 
  colnames() %>% as.data.frame()

# Bd GENETIC #
serdp_bd_genom <- dbGetQuery(connection, "select * from serdp_bd_genomic")%>% 
  colnames() %>% as.data.frame()

# full in memeory cap table
full_cap_data <- tbl(connection, "location") %>%
  inner_join(tbl(connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(connection, "capture"), by = c("survey_id")) %>%
  left_join(tbl(connection, "temp_shiny_bd"), by = c("bd_swab_id")) %>% 
  left_join(tbl(connection, "serdp_bd_genomic"), by = c("genetic_id")) %>% 
  left_join(tbl(connection, "serdp_newt_microbiome_mucosome_antifungal"), by = c("mucosome_id", "microbiome_swab_id")) %>% 
  left_join(tbl(connection, "serdp_amp"), by = c("amp_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, capture_id))



# full cap minus processed data
no_pros_cap_data <- tbl(connection, "location") %>%
  inner_join(tbl(connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(connection, "capture"), by = c("survey_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, capture_id))


# ves
ves <- dbGetQuery(connection, "select * from ves") 
ves <- select(ves, !c(survey_id, ves_id)) %>% 
  colnames() %>% as.data.frame()

# full in memory ves table
full_ves_data <- tbl(connection, "location") %>%
  inner_join(tbl(connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(connection, "ves"), by = c("survey_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id))





# dbExecute(connection, "set search_path = survey_data")
# 
# location <- read_csv(here("RIBBiTR_DataRepository", "data", "location.csv"))
# 
# region <- read_csv(here("RIBBiTR_DataRepository", "data", "region.csv"))
# 
# site_list <- read_csv(here("RIBBiTR_DataRepository", "data", "site_list.csv"))
# 
# site <- read_csv(here("RIBBiTR_DataRepository", "data", "site.csv"))
# 
# years <- read_csv(here("RIBBiTR_DataRepository", "data", "year.csv"))
# 
# visit <- read_csv(here("RIBBiTR_DataRepository", "data", "visit.csv"))
# 
# survey <- read_csv(here("RIBBiTR_DataRepository", "data", "survey.csv"))
# 
# capture <- read_csv(here("RIBBiTR_DataRepository", "data", "capture.csv"))

# slow method for reading in all csv files

# filenames <- gsub("\\.csv$","", list.files(here("data")))

 # for(i in filenames){
 #   assign(i, read_csv(here("data", paste(i, ".csv", sep=""))))
 # }

 # visit <- read_csv(here("RIBBiTR_DataRepository/data/visit.csv"))
 # 
 # ves <- read_csv(here("RIBBiTR_DataRepository/data/ves.csv"))
 # 
 # ves_cols <- read_csv(here("RIBBiTR_DataRepository/data/ves_cols.csv"))
 # 
 # survey <- read_csv(here("RIBBiTR_DataRepository/data/survey.csv"))
 # 
 # site <- read_csv(here("RIBBiTR_DataRepository/data/site.csv"))
 # 
 # serdp_muc_mic <- read_csv(here("RIBBiTR_DataRepository/data/serdp_muc_mic.csv"))
 # 
 # serdp_bd_genom <- read_csv(here("RIBBiTR_DataRepository/data/serdp_bd_genom.csv"))
 # 
 # serdp_amp <- read_csv(here("RIBBiTR_DataRepository/data/serdp_amp.csv"))
 # 
 # region <- read_csv(here("RIBBiTR_DataRepository/data/region.csv"))
 # 
 # location <- read_csv(here("RIBBiTR_DataRepository/data/location.csv"))
 # 
 # hobo <- read_csv(here("RIBBiTR_DataRepository/data/hobo.csv"))
 # 
 # hobo_site <- read_csv(here("RIBBiTR_DataRepository/data/hobo_site.csv"))
 # 
 # hobo_region <- read_csv(here("RIBBiTR_DataRepository/data/hobo_region.csv"))
 # 
 # hobo_location <- read_csv(here("RIBBiTR_DataRepository/data/hobo_location.csv"))
 # 
 # hobo_cols <- read_csv(here("RIBBiTR_DataRepository/data/hobo_cols.csv"))
 # 
 # comb_bd <- read_csv(here("RIBBiTR_DataRepository/data/comb_bd.csv"))
 # 
 # capture <- read_csv(here("RIBBiTR_DataRepository/data/capture.csv"))
 # 
 # aural <- read_csv(here("RIBBiTR_DataRepository/data/aural.csv"))
 # 
 # cap <- read_csv(here("RIBBiTR_DataRepository/data/cap.csv"))
 # 
 # aural_cols <- read_csv(here("RIBBiTR_DataRepository/data/aural_cols.csv"))
 # 
 # audio_cols <- read_csv(here("RIBBiTR_DataRepository/data/audio_cols.csv"))
 # 
 # audio_location <- read_csv(here("RIBBiTR_DataRepository/data/audio_location.csv"))
 # 
 # audio_region <- read_csv(here("RIBBiTR_DataRepository/data/audio_region.csv"))
 # 
 # audio_site <- read_csv(here("RIBBiTR_DataRepository/data/audio_site.csv"))
 # 
 # audio_visit <- read_csv(here("RIBBiTR_DataRepository/data/audio_visit.csv"))
 # 
 # audio <- read_csv(here("RIBBiTR_DataRepository/data/audio.csv"))


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


# remove NA function
not_all_na <- function(x) any(!is.na(x))

