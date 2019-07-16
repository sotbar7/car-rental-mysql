#####################################################
# SOTIRIOS BARATSAS (f2821803) & NIKOLAOS SPANOS (f2821826) #
#####################################################

### QUESTION 4 ###

# install.packages("DBI")
# install.packages("RMySQL")

library(DBI)
library(RMySQL)

customersdf <- read.csv(file="Assignment_1_Customers.csv", header=TRUE, sep=",")

#You need to input your own database name, username and password here
mydb <- dbConnect(dbDriver("MySQL"), user = "root", password="f2821803", dbname = "crc", host="localhost", port=3306)

dbWriteTable(mydb, value = customersdf, row.names = FALSE, name = "customers", append = TRUE) 
dbReadTable(mydb, "customers")

### DISCONNECT FROM DATABASE ###
dbDisconnect(mydb)