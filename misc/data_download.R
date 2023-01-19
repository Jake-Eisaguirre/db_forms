if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}

# librarian downloads, if not already downloaded, and reads in needed packages
librarian::shelf(tidyverse, here, janitor, sf, lubridate, RPostgres, DBI)



# DB conection
tryCatch({
  drv <- dbDriver("Postgres")
  print("Connecting to Database…")
  connection <- dbConnect(drv, 
                          dbname = Sys.getenv("dbname"),
                          host = Sys.getenv("host"), 
                          port = Sys.getenv("port"),
                          user = Sys.getenv("user"), 
                          password = Sys.getenv("password"))
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})


dbExecute(connection, "set search_path = survey_data")

location <- dbGetQuery(connection, "select * from location;")
write_csv(location, here("data", "location.csv"))

region <- dbGetQuery(connection, "select * from region;")
write_csv(region, here("data", "region.csv"))

site <- dbGetQuery(connection, "select * from site") 
site <- select(site, !c(site_id, region_id))
write_csv(site, here("data", "site.csv"))

visit <- dbGetQuery(connection, "select * from visit") %>% 
  drop_na(date) %>% 
  mutate(year = year(date),
         year = )
visit <- select(visit, !c(site_id, visit_id))
write_csv(visit, here("data", "visit.csv"))

survey <- dbGetQuery(connection, "select * from survey")
survey <- select(survey, !c(visit_id, survey_id))
write_csv(survey, here("data", "survey.csv"))

capture <- dbGetQuery(connection, "select * from capture") 
capture <- select(capture, !c(survey_id, capture_id))
write_csv(capture, here("data", "capture.csv"))

ves_cols <- dbGetQuery(connection, "select * from ves")
ves_cols <- select(ves_cols, !c(survey_id, ves_id))
write_csv(ves_cols, here("data", "ves_cols.csv"))

aural_cols <- dbGetQuery(connection, "select * from aural")
aural_cols <- select(aural_cols, !c(survey_id, aural_id))
write_csv(aural_cols, here("data", "aural_cols.csv"))

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
write_csv(cap, here("data", "cap.csv"))

################

##### Proccesed swabs ########

# BD #
serdp_bd <- dbGetQuery(connection, "select * from serdp_bd")

sn_bd <- dbGetQuery(connection, "select * from sierra_nevada_bd")

pan_bd <- dbGetQuery(connection, "select * from panama_bd_temp")

comb_bd <- plyr::rbind.fill(serdp_bd, sn_bd, pan_bd) 
write_csv(comb_bd, here("data", "comb_bd.csv"))

# AMP #
serdp_amp <- dbGetQuery(connection, "select * from serdp_amp")
write_csv(serdp_amp, here("data", "serdp_amp.csv"))

# Muc/microbiome #
serdp_muc_mic <- dbGetQuery(connection, "select * from serdp_newt_microbiome_mucosome_antifungal") 
write_csv(serdp_muc_mic, here("data", "serdp_muc_mic.csv"))

# Bd GENETIC #
serdp_bd_genom <- dbGetQuery(connection, "select * from serdp_bd_genomic")
write_csv(serdp_bd_genom, here("data", "serdp_bd_genom.csv"))

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
write_csv(ves, here("data", "ves.csv"))
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
write_csv(aural, here("data", "aural.csv"))
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
write_csv(hobo, here("data", "hobo.csv"))

hobo_location <- dbGetQuery(connection, "select location from hobo_location")
write_csv(hobo_location, here("data", "hobo_location.csv"))

hobo_region <- dbGetQuery(connection, "select region from hobo_region")
write_csv(hobo_region, here("data", "hobo_region.csv"))

hobo_site <- dbGetQuery(connection, "select * from hobo_site")  
hobo_site <- select(hobo_site, !c(hobo_site_id, hobo_region_id))
write_csv(hobo_site, here("data", "hobo_site.csv"))

hobo_cols <- dbGetQuery(connection, "select * from hobo")
hobo_cols <- select(hobo_cols, !c(hobo_id, hobo_site_id)) %>% 
  mutate(year = year(date_time))
write_csv(hobo_cols, here("data", "hobo_cols.csv"))

#################
