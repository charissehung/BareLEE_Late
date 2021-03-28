# automated_attendance
## Allow teachers to automate class attendance from Zoom Usage Report
### Created by Joshua Li, Esther Foo, and Charisse Hung for LA Hacks 2021

## Inspiration
In person, attendance isn’t given a second thought in the classroom. However, because of the limited time during online learning, teachers need to maximize efficiency in the classroom. To do this we can push checking attendance to after class has ended, and automate the process so that the teacher doesn’t have to manually find every student.

## What it does
When a class is on Zoom, the teacher is able to download the Zoom Usage Report which lists participants and information including their join time and their total duration in the meeting. We take that data and compare it to the attendance list, marking absences and lates when the teacher inputs cutoff time (late) and a minimum time requirement to be counted as fully present. We account for the same person joining multiple times and upper/lowercase names. 

## How we built it
Our project uses R (programming language) and the Shiny package. We read in the two csv files (the Zoom Usage Report & the attendance list). From the Zoom Usage Report, we are able to manipulate the data to add up the total time a person participated in the Zoom, regardless if they left multiple times or changed devices given their name is the same. We see if the total time of attendance reaches the minimum threshold to be counted as present. The student's join time will also be compared to the inputted cutoff time to check if they joined the Zoom late. The final output gives names on the attendance list along with a column marking if they were "0" (fully present and on time), "L" (late), or "A" (absent).

