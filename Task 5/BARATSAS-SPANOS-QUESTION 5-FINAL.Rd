#####################################################
# SOTIRIOS BARATSAS (f2821803) & NIKOLAOS SPANOS (f2821826) #
#####################################################


## QUESTION 5 ###


# install.packages("DBI")
# install.packages("RMySQL")

library(DBI)
library(RMySQL)

#You need to input your own database name, username and password here
mydb <- dbConnect(dbDriver("MySQL"), user = "root", password="f2821803", dbname = "crc", host="localhost", port=3306)


monthlist = list()
for (i in 1:12) {
	query<-paste("select sum(amount) from reservations where year(p_date)=2015 AND month(p_date)=", i,";", sep="")
	sendquery <- dbSendQuery(mydb, query)
	data <- fetch(sendquery, n=1)
	dbClearResult(sendquery)
	data$month<- i
	monthlist[[i]] <- data
}
MonthTotal= do.call(rbind, monthlist); names(MonthTotal)<-c("MonthlyTotal", "Month")
MonthTotal[is.na(MonthTotal)] <- 0

PreviousMonths<-0
NextMonths<-sum(MonthTotal$MonthlyTotal)
Totals = list()
Totals <- NULL
for (i in 1:12) {
	CurrentMonth<-MonthTotal[i,1]
	NextMonths<-NextMonths-CurrentMonth
	Totals[[i]]<-c(i, PreviousMonths, CurrentMonth, NextMonths)
	PreviousMonths <-PreviousMonths + MonthTotal[[i,1]]
}
Totals <- data.frame(do.call(rbind, Totals)); names(Totals)<-c("Month", "Previous Months", "Current Month", "Next Months");
print(Totals)

### DISCONNECT FROM DATABASE ###
dbDisconnect(mydb)


