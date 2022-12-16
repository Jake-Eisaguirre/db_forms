if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}

# librarian downloads, if not already downloaded, and reads in needed packages

librarian::shelf(tidyverse, here, janitor, shiny, lubridate, RPostgres, rstudioapi, shinyWidgets, DT, glue, shinycssloaders, DBI)


#connect to database
connection <- dbConnect(dbDriver("Postgres"),
                        dbname = Sys.getenv("dbname"),
                        host = Sys.getenv("host"),
                        port = Sys.getenv("port"),
                        user = Sys.getenv("user"),
                        password = Sys.getenv("password"))

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

######### eDNA ########
# dbExecute(connection, "set search_path = hobo")
# 
# raw_dna <- dbGetQuery(connection, "select hobo_site.*, shade_hobo.*, soil_hobo.*, sun_hobo.*, water_hobo.*
#                                    from hobo_site
#                                    join shade_hobo on hobo_site.hobo_site_id = shade_hobo.hobo_site_id
#                                    join soil_hobo on  hobo_site.hobo_site_id = soil_hobo.hobo_site_id
#                                    join sun_hobo on  hobo_site.hobo_site_id = sun_hobo.hobo_site_id
#                                    join water_hobo on  hobo_site.hobo_site_id = water_hobo.hobo_site_id")

