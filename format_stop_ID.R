# use the online resource managed by Verbruggen at  
# https://github.com/fredvbrug/STOP-IT/blob/master/Tscope_version/README-ANALYZE-IT-Tscope.md 
# to process OLD stop data using current best practices

### format ID in individual stop data ###
rm(list=ls()) # clear the working directory

setwd("C:/Users/Paulie/Desktop/SST/STOP-IT/") # set working directory

datafile <- "stop_individual_data.csv" # set datafile name
df <- read.csv(datafile) # make data.frame from .csv

ID <- as.vector(df$subject) # create vector of subject column

ID1 <- gsub("stop-", "", ID) # remove stop- prefix from ID
ID1 <- gsub(".txt", "", ID1) # remove .txt extension from ID

df2 <- subset(df, select= -c(subject)) # remove subject column
df <- cbind(ID1, df2) # combine new subject column and data

IDdatafile <- "stopdata.csv" # set new datafile name

write.csv(df, "stopdata.csv" ) # write to csv file

### extract time and add to datafile ###

datafile <- "stopdata.csv" # set datafile name
data <- read.csv(datafile, header=T) # read data into data.frame
time <- as.character() # set empty character vector for mtime
combine <- data.frame() # set empty data.frame

setwd("C:/Users/Paulie/Desktop/SST/STOP-IT/") # set working directory

n = length(ID)
for(i in 1:n)	
	{
	IDfile <- ID[i]
	subject <- read.table(IDfile)
	tmp <- as.character(file.info(IDfile)$mtime)
	time <- rbind(time, tmp)
	}

combine <- cbind(data, time)

write.csv(combine, "stopdatadate.csv" ) # write to csv file
