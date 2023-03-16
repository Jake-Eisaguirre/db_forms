
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




########## survey_data ##########

######### survey_data #########

# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  survey_data_connection <- dbConnect(drv, 
                                      dbname = Sys.getenv("aws_dbname"),
                                      host = Sys.getenv("aws_host"), 
                                      port = Sys.getenv("aws_port"),
                                      user = Sys.getenv("aws_user"), 
                                      password = Sys.getenv("aws_password"))
  dbExecute(survey_data_connection, "set search_path = 'survey_data'")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})

# years slider
years <- dbGetQuery(survey_data_connection, "select date from visit") %>% 
  mutate(year = year(date)) %>% 
  filter(!duplicated(year)) %>% 
  select(!c(date)) %>% 
  drop_na()

# BD #

comb_bd <-  dbGetQuery(survey_data_connection, "select * from temp_shiny_bd") %>% 
  colnames() %>% as.data.frame() %>% rename("Temp Bd" = ".")

# AMP #
serdp_amp <- dbGetQuery(survey_data_connection, "select * from serdp_amp")%>% 
  colnames() %>% as.data.frame() %>% rename("Amp Variables" = ".")

# Muc/microbiome #
serdp_muc_mic <- dbGetQuery(survey_data_connection, "select * from serdp_newt_microbiome_mucosome_antifungal") %>% 
  colnames() %>% as.data.frame() %>% rename("Mucosome & Microbiome Variables" = ".")

# Bd GENETIC #
serdp_bd_genom <- dbGetQuery(survey_data_connection, "select * from serdp_bd_genomic")%>% 
  colnames() %>% as.data.frame() %>% rename("Bd Genomic Variables" = ".")

# full in memeory cap table
full_cap_data <- tbl(survey_data_connection, "location") %>%
  inner_join(tbl(survey_data_connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(survey_data_connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(survey_data_connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(survey_data_connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(survey_data_connection, "capture"), by = c("survey_id")) %>%
  left_join(tbl(survey_data_connection, "temp_shiny_bd"), by = c("bd_swab_id")) %>% 
  left_join(tbl(survey_data_connection, "serdp_bd_genomic"), by = c("genetic_id")) %>% 
  left_join(tbl(survey_data_connection, "serdp_newt_microbiome_mucosome_antifungal"), by = c("mucosome_id", "microbiome_swab_id")) %>% 
  left_join(tbl(survey_data_connection, "serdp_amp"), by = c("amp_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, capture_id))



# full cap minus processed data
no_pros_cap_data <- tbl(survey_data_connection, "location") %>%
  inner_join(tbl(survey_data_connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(survey_data_connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(survey_data_connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(survey_data_connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(survey_data_connection, "capture"), by = c("survey_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, capture_id))


# full in memory ves table
full_ves_data <- tbl(survey_data_connection, "location") %>%
  inner_join(tbl(survey_data_connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(survey_data_connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(survey_data_connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(survey_data_connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(survey_data_connection, "ves"), by = c("survey_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, ves_id))



# full in memory aural table
full_aural_data <- tbl(survey_data_connection, "location") %>%
  inner_join(tbl(survey_data_connection, "region"), by = c("location_id")) %>%
  inner_join(tbl(survey_data_connection, "site"), by = c("region_id")) %>%
  inner_join(tbl(survey_data_connection, "visit"), by = c("site_id")) %>%
  inner_join(tbl(survey_data_connection, "survey"), by = c("visit_id")) %>%
  inner_join(tbl(survey_data_connection, "aural"), by = c("survey_id")) %>%
  mutate(year = year(date)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, aural_id))

######## END Survey Data #########

####### HOBO Data ###########

# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  hobo_connection <- dbConnect(drv, 
                               dbname = Sys.getenv("aws_dbname"),
                               host = Sys.getenv("aws_host"), 
                               port = Sys.getenv("aws_port"),
                               user = Sys.getenv("aws_user"), 
                               password = Sys.getenv("aws_password"))
  dbExecute(hobo_connection, "set search_path = 'hobo'")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})

# hobo years
hobo_years <- tbl(hobo_connection, "hobo") %>% 
  mutate(year = year(date_time)) %>% 
  select(year) %>%
  distinct(year) %>%
  collect() %>% 
  drop_na()

# full in memory hobo table
full_hobo_data <- tbl(hobo_connection, "hobo_location") %>% 
  inner_join(tbl(hobo_connection, "hobo_region"), by = c("hobo_location_id")) %>% 
  inner_join(tbl(hobo_connection, "hobo_site"), by = c("hobo_region_id")) %>% 
  inner_join(tbl(hobo_connection, "hobo"), by = c("hobo_site_id")) %>% 
  mutate(year = year(date_time)) %>% 
  select(!c(hobo_location_id, hobo_region_id, hobo_site_id, hobo_id))

########## END HOBO ###################

########## Audio #####################

# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  audio_connection <- dbConnect(drv, 
                               dbname = Sys.getenv("aws_dbname"),
                               host = Sys.getenv("aws_host"), 
                               port = Sys.getenv("aws_port"),
                               user = Sys.getenv("aws_user"), 
                               password = Sys.getenv("aws_password"))
  dbExecute(audio_connection, "set search_path = 'audio'")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})

# full in memory audio table
full_audio_data <- tbl(audio_connection, "audio_location") %>% 
  inner_join(tbl(audio_connection, "audio_region"), by = c("location_id")) %>% 
  inner_join(tbl(audio_connection, "audio_site"), by = c("region_id")) %>% 
  inner_join(tbl(audio_connection, "audio_visit"), by = c("site_id")) %>%
  inner_join(tbl(audio_connection, "audio_info"), by  = c("visit_id")) %>% 
  mutate(year = year(date_of_deployment)) %>% 
  select(!c(location_id, region_id, site_id, visit_id, audio_id))


audio_years <- tbl(audio_connection, "audio_visit") %>% 
  mutate(year = year(date_of_deployment)) %>% 
  distinct(year) %>% 
  select(year) %>%
  collect() %>% 
  as.data.frame() %>% 
  drop_na()

######## END Audio Data #########


############ eDNA Data

# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  edna_connection <- dbConnect(drv, 
                               dbname = Sys.getenv("aws_dbname"),
                               host = Sys.getenv("aws_host"), 
                               port = Sys.getenv("aws_port"),
                               user = Sys.getenv("aws_user"), 
                               password = Sys.getenv("aws_password"))
  dbExecute(edna_connection, "set search_path = 'e_dna'")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})


full_edna_data <- dbGetQuery(edna_connection, "select el.*, er.*, es.*, ev.*, es2.*
                                               from edna_location el 
                                               join edna_region er on el.location_id = er.location_id 
                                               join edna_site es on er.region_id = es.region_id
                                               join edna_visit ev on es.site_id = ev.site_id
                                               join edna_survey es2 on ev.visit_id = es2.visit_id;") %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id, location_id..5, location..8, region_id..19,
            site_id..28, visit_id..45))


edna_years <- full_edna_data %>% 
  select(year) %>%
  distinct(year) %>% 
  drop_na()



# a <- full_ves_data %>% filter(year %in% c(2017:2022),
#                               location %in% c("usa"),
#                               region %in% c("california"),
#                               site %in% c("70449")) %>%  collect()

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

