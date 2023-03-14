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

######### survey_data #########

dbExecute(connection, "set search_path = survey_data")

location <- dbGetQuery(connection, "select location from location;")
write_csv(location, here("RIBBiTR_DataRepository", "data", "location.csv"))

region <- region <- dbGetQuery(connection, "select region from region;")
write_csv(region, here("RIBBiTR_DataRepository", "data", "region.csv"))

site_list <- dbGetQuery(connection, "select site from site") 
write_csv(site_list, here("RIBBiTR_DataRepository", "data", "site_list.csv"))

site <- dbGetQuery(connection, "select * from site") %>% 
  colnames() %>% data.frame()
write_csv(site, here("RIBBiTR_DataRepository", "data", "site.csv"))

years <- dbGetQuery(connection, "select date from visit") %>% 
  mutate(year = year(date)) %>% 
  filter(!duplicated(year)) %>% 
  select(!c(date)) %>% 
  drop_na()
write_csv(years, here("RIBBiTR_DataRepository", "data", "year.csv"))

visit <- dbGetQuery(connection, "select * from visit") %>% 
  select(!c(visit_id, site_id)) %>% 
  colnames() %>%  data.frame()
write_csv(visit, here("RIBBiTR_DataRepository", "data", "visit.csv"))

survey <- dbGetQuery(connection, "select * from survey")
survey <- select(survey, !c(visit_id, survey_id)) %>% 
  colnames() %>% as.data.frame()
write_csv(survey, here("RIBBiTR_DataRepository", "data", "survey.csv"))

capture <- dbGetQuery(connection, "select * from capture") 
capture <- select(capture, !c(survey_id, capture_id)) %>% 
  colnames() %>% as.data.frame()
write_csv(capture, here("RIBBiTR_DataRepository", "data", "capture.csv"))


# BD #
serdp_bd <- dbGetQuery(connection, "select * from serdp_bd") %>% 
  colnames() %>% as.data.frame()

sn_bd <- dbGetQuery(connection, "select * from sierra_nevada_bd")%>% 
  colnames() %>% as.data.frame()

pan_bd <- dbGetQuery(connection, "select * from panama_bd_temp")%>% 
  colnames() %>% as.data.frame()

comb_bd <- plyr::rbind.fill(serdp_bd, sn_bd, pan_bd) 
write_csv(comb_bd, here("RIBBiTR_DataRepository", "data", "comb_bd.csv"))

# AMP #
serdp_amp <- dbGetQuery(connection, "select * from serdp_amp")%>% 
  colnames() %>% as.data.frame()
write_csv(serdp_amp, here("RIBBiTR_DataRepository", "data", "serdp_amp.csv"))

# Muc/microbiome #
serdp_muc_mic <- dbGetQuery(connection, "select * from serdp_newt_microbiome_mucosome_antifungal") %>% 
  colnames() %>% as.data.frame()
write_csv(serdp_muc_mic, here("RIBBiTR_DataRepository", "data", "serdp_muc_mic.csv"))

# Bd GENETIC #
serdp_bd_genom <- dbGetQuery(connection, "select * from serdp_bd_genomic")%>% 
  colnames() %>% as.data.frame()
write_csv(serdp_bd_genom, here("RIBBiTR_DataRepository", "data", "serdp_bd_genom.csv"))

