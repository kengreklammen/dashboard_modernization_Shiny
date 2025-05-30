source("R_scripts/connect_db.R")

con <- connect_db()
DBI::dbExecute(con, "SET search_path TO student_arpad;")

dem_res <- DBI::dbGetQuery(con, "SELECT * FROM jobseekers_by_idemnisee;")
dem_mes <- DBI::dbGetQuery(con, "SELECT * FROM jobseekers_by_mesure;")
dem_nat <- DBI::dbGetQuery(con, "SELECT * FROM jobseekers_by_nationality;")
dem_gen <- DBI::dbGetQuery(con, "SELECT * FROM jobseekers_by_age;")
dem_dur <- DBI::dbGetQuery(con, "SELECT * FROM jobseekers_by_age_duree;")
offr_det <- DBI::dbGetQuery(con, "SELECT * FROM joboffers_detailed;")
offr_simple <- DBI::dbGetQuery(con, "SELECT * FROM joboffers_simple;")

DBI::dbDisconnect(con)

#View(dem_res)
#View(dem_mes)
#View(dem_nat)
#View(dem_gen)
#View(dem_dur)
#View(offr_det)
#View(offr_simple)
