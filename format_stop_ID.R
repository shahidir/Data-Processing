
rm(list=ls()) # clear the working directory

setwd("C:/Users/Paulie/Desktop/SST/") # set working directory

datafile <- "STOP-IT/stop_individual_data.csv" # set datafile name
df <- read.csv(datafile) # make data.frame from .csv

ID <- as.vector(df$subject) # create vector of subject column

ID <- gsub("stop-", "", ID) # remove stop- prefix from ID
ID <- gsub(".txt", "", ID) # remove .txt extension from ID

df2 <- subset(df, select= -c(subject)) # remove subject column
df <- cbind(ID, df2) # combine new subject column and data

IDdatafile <- "stopdata.csv" # set new datafile name

write.csv(df, "stopdata.csv" ) # write to csv file
