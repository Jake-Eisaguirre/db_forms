
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}

# librarian downloads, if not already downloaded, and reads in needed packages

librarian::shelf(tidyverse, here, janitor, lubridate, RPostgres, rstudioapi, shinyWidgets, DT, glue, shinycssloaders, DBI, gargle,
                 shinyalert, googledrive, shinylogs, cachem, shinymanager,
                 shiny)

source(here("RIBBiTR_DataRepository", "db_creds_goog.R"))

# options(gargle_oauth_email = TRUE,
#          # specify auth tokens should be stored in a hidden directory ".secrets"
#          gargle_oauth_cache = "RIBBiTR_DataRepository/db_creds_goog.R")

drive_auth(email = goog_email)

shinyOptions(cache = cachem::cache_disk("./app_cache"))
#shinyOptions(cache = cachem::cache_mem(max_size = 1000e6))


#connect to database
connection <- dbConnect(dbDriver("Postgres"),
                        dbname = dbname,
                        host = host,
                        port = port,
                        user = user,
                        password = password)

dbExecute(connection, "set search_path = survey_data")

location <- dbGetQuery(connection, "select * from location;")

region <- dbGetQuery(connection, "select * from region;")

site <- dbGetQuery(connection, "select * from site") 
site <- select(site, !c(site_id, region_id))

visit <- dbGetQuery(connection, "select * from visit") %>% 
  drop_na(date) %>% 
  mutate(year = year(date))
visit <- select(visit, !c(site_id, visit_id))

survey <- dbGetQuery(connection, "select * from survey")
survey <- select(survey, !c(visit_id, survey_id))

capture <- dbGetQuery(connection, "select * from capture") 
capture <- select(capture, !c(survey_id, capture_id))

ves_cols <- dbGetQuery(connection, "select * from ves")
ves_cols <- select(ves_cols, !c(survey_id, ves_id))

aural_cols <- dbGetQuery(connection, "select * from aural")
aural_cols <- select(aural_cols, !c(survey_id, aural_id))

###### CAP ######
raw_cap  <- dbGetQuery(connection, "select l.*, r.*, s.*, v.*, su.*, c.*
                                    from location l
                                    join region r on l.location_id = r.location_id 
                                    join site s on r.region_id = s.region_id 
                                    join visit v on s.site_id = v.site_id 
                                    join survey su on v.visit_id = su.visit_id 
                                    join capture c on su.survey_id = c.survey_id;")


cap <- raw_cap %>%
  select(!c(location_id, region_id, site_id, visit_id, survey_id)) %>% 
  drop_na(date) %>% 
  mutate(year = year(date))
################

##### Proccesed swabs ########

# BD #
serdp_bd <- dbGetQuery(connection, "select * from serdp_bd")

sn_bd <- dbGetQuery(connection, "select * from sierra_nevada_bd")

pan_bd <- dbGetQuery(connection, "select * from panama_bd_temp")

comb_bd <- plyr::rbind.fill(serdp_bd, sn_bd, pan_bd) 

# AMP #
serdp_amp <- dbGetQuery(connection, "select * from serdp_amp")

# Muc/microbiome #
serdp_muc_mic <- dbGetQuery(connection, "select * from serdp_newt_microbiome_mucosome_antifungal") 

# Bd GENETIC #
serdp_bd_genom <- dbGetQuery(connection, "select * from serdp_bd_genomic")

##### VES #######
raw_ves <- dbGetQuery(connection, "select l.*, r.*, s.*, v.*, su.*, c.*
                                    from location l
                                    join region r on l.location_id = r.location_id 
                                    join site s on r.region_id = s.region_id 
                                    join visit v on s.site_id = v.site_id 
                                    join survey su on v.visit_id = su.visit_id 
                                    join ves c on su.survey_id = c.survey_id;")
ves <- raw_ves %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id)) %>% 
  drop_na(date) %>% 
  mutate(year = year(date))
###############

####### AURAL ########
raw_aural <- dbGetQuery(connection, "select l.*, r.*, s.*, v.*, su.*, c.*
                                    from location l
                                    join region r on l.location_id = r.location_id 
                                    join site s on r.region_id = s.region_id 
                                    join visit v on s.site_id = v.site_id 
                                    join survey su on v.visit_id = su.visit_id 
                                    join aural c on su.survey_id = c.survey_id;")
aural <- raw_aural %>% 
  select(!c(location_id, region_id, site_id, visit_id, survey_id)) %>% 
  drop_na(date) %>% 
  mutate(year = year(date))
#################

######### hobo ########
dbExecute(connection, "set search_path = hobo")

raw_hobo <- dbGetQuery(connection, "select hl.*, hr.*, hs.*, h.*
                                   from hobo_location hl 
                                   join hobo_region hr on hl.hobo_location_id = hr.hobo_location_id 
                                   join hobo_site hs on hr.hobo_region_id = hs.hobo_region_id 
                                   join hobo h on hs.hobo_site_id = h.hobo_site_id;")

hobo <- raw_hobo %>% 
  select(!c(hobo_location_id, hobo_region_id, hobo_location_id..5, hobo_site_id, hobo_region_id..13, hobo_id, hobo_site_id..25)) %>% 
  mutate(year = year(date_time))

hobo_location <- dbGetQuery(connection, "select location from hobo_location")

hobo_region <- dbGetQuery(connection, "select region from hobo_region")

hobo_site <- dbGetQuery(connection, "select * from hobo_site")  
hobo_site <- select(hobo_site, !c(hobo_site_id, hobo_region_id))

hobo_cols <- dbGetQuery(connection, "select * from hobo")
hobo_cols <- select(hobo_cols, !c(hobo_id, hobo_site_id)) %>% 
  mutate(year = year(date_time))

#################


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
