if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}

# librarian downloads, if not already downloaded, and reads in needed packages

librarian::shelf(tidyverse, here, janitor, shiny, lubridate, RPostgres, rstudioapi, shinyWidgets, DT, glue, shinycssloaders, DBI)



filenames <- gsub("\\.csv$","", list.files(here("data", "clean_tables")))

for(i in filenames){
  assign(i, read.csv(here("data", "clean_tables", paste(i, ".csv", sep=""))))
}


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

visit <- dbGetQuery(connection, "select * from visit")

penn_survey <- dbGetQuery(connection, "select * from penn_survey")

serdp_survey <- dbGetQuery(connection, "select * from serdp_survey")

brazil_legacy_survey <- dbGetQuery(connection, "select * from brazil_legacy_survey")

panama_survey <- dbGetQuery(connection, "select * from panama_survey")

capture <- dbGetQuery(connection, "select * from capture")

ves <- dbGetQuery(connection, "select * from ves")

aural <- dbGetQuery(connection, "select * from aural")



# 
# all_data <- as.data.frame(dbGetQuery(connection, "
#                                       select l.*, r.*, s.*, v.*, ps.*, c.* 
#                                       from location l
#                                       join region r on l.location_id = r.location_id 
#                                       join site s on r.region_id = s.region_id 
#                                       join visit v on s.site_id = v.site_id 
#                                       join panama_survey ps on v.visit_id = ps.visit_id 
#                                       join capture c on ps.panama_survey_id = c.panama_survey_id 
#                                       union all
#                                       select l.*, r.*, s.*, v.*, p.*, c.*  
#                                       from location l
#                                       join region r on l.location_id = r.location_id 
#                                       join site s on r.region_id = s.region_id 
#                                       join visit v on s.site_id = v.site_id 
#                                       join penn_survey p on v.visit_id = p.visit_id 
#                                       join capture c on p.penn_survey_id = c.penn_survey_id 
#                                       union all
#                                       select l.*, r.*, s.*, v.*, sns.*, c.*  
#                                       from location l
#                                       join region r on l.location_id = r.location_id 
#                                       join site s on r.region_id = s.region_id 
#                                       join visit v on s.site_id = v.site_id 
#                                       join sierra_nevada_survey sns on v.visit_id = sns.visit_id 
#                                       join capture c on sns.sierra_nevada_survey_id = c.sierra_nevada_survey_id
#                                       join sierra_nevada_bd snb on c.bd_swab_id = snb.bd_swab_id 
#                                       union all
#                                       select l.*, r.*, s.*, v.*, bls.*, c.*  
#                                       from location l
#                                       join region r on l.location_id = r.location_id 
#                                       join site s on r.region_id = s.region_id 
#                                       join visit v on s.site_id = v.site_id 
#                                       join brazil_legacy_survey bls on v.visit_id = bls.visit_id 
#                                       join capture c on bls.brazil_legacy_survey_id = c.brazil_legacy_survey_id
#                                       union all
#                                       select l.*, r.*, s.*, v.*, ss.*, c.*  
#                                       from location l
#                                       join region r on l.location_id = r.location_id 
#                                       join site s on r.region_id = s.region_id 
#                                       join visit v on s.site_id = v.site_id 
#                                       join serdp_survey ss on v.visit_id = ss.visit_id 
#                                       join capture c on ss.serdp_survey_id = c.serdp_survey_id
#                                       join serdp_bd sb on c.bd_swab_id = sb.bd_swab_id"))
