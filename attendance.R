library(tidyverse)

goc <- read_csv("./clean_zoom_attendance.csv")
roster <- write_csv("./attendance.csv")

attendance <- function(att_table, zoom_table, late_time, absent_time) {
  colnames(zoom_table) <- c("Name", "Email", "Join_Time", "Leave_Time", "Duration", "Guest")
  zoom_table <- zoom_table %>% arrange(Name)
  zoom_table$Name <- toupper(zoom_table$Name)
  join_clock <- character(length(zoom_table$Join_Time))
  for (i in 1:length(zoom_table$Join_Time)) {
    join_clock[i] <- strsplit(zoom_table$Join_Time[i], " ")[[1]][2] # finding the time part
  }
  zoom_table <- cbind(zoom_table, join_clock)
  zoom_table <- zoom_table %>% group_by(Name) %>% mutate(start_Time = as.character(join_clock[1])) # this is when the person first comes into the Zoom
  zoom_table <- zoom_table %>% group_by(Name) %>% mutate(total_Duration = sum(Duration)) # how long each person stays
  summary_table <- zoom_table %>% 
    group_by(Name) %>% 
    summarise(tardy = if (total_Duration < absent_time) {"A"}
              else if (start_Time > late_time) {"L"}
              else {"0"}
              )
  colnames(att_table) <- c("Name")
  att_table$Name <- toupper(att_table$Name)
  new_attendance <- att_table %>% left_join(summary_table, by = c("Name")) # did a left join
   for (i in 1:length(new_attendance$Name)) { # replaces NA's with A
     if (is.na(new_attendance$tardy[i]))
       new_attendance$tardy[i] <- "A"
   }
  new_attendance
}

attendance(roster, goc, "20:10", 50)
attendance(roster, goc, "20:10", 100)
attendance(roster, goc, "20:00", 100)
