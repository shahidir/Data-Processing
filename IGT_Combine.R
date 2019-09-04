rm(list=ls())
library(foreign)
library(stringr)
#All IGT files must be named as IGT_subjID_Date.txt
#_ can be -, date can be mm-dd-yy or mm-dd-yyyy or any format with 2 "-"

#setwd( "~/Desktop/Impulsivity" ) #Sets working directory to folder where SPSS file is
#logData <- read.spss("R01 IMPULSIIVITY DATABASE 4-24-2019.sav",to.data.frame=TRUE, use.value.labels=FALSE) #This is if there is a master database, all code relating to master database highlighted out



# Changing IQDAT to txt files in same format ------------------------------
setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/IGT Inquisit" ) #Sets working directory to folder where the IQDAT files are
allFiles = dir() #Gets directory of the raw files
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  tmpFile = allFiles[ subjIdx ]
  tmp= read.table(tmpFile, header=T, colClasses=c(date="character", subject="character")) #Imports data, keeps values in date and subject as character
  df<-tmp[,c("values.cardsselected", "response", "values.gain", "values.loss", "values.currenttotal", "latency", "subject", "date")] #Gets columns of interest
  df$date<-sub("\\s+$", "", gsub('(.{2})', '\\1-', df$date)) #Places spaces every two characters in date column
  df$date<-substr(df$date,1,nchar(df$date)-1) #Removes trailing dash
  colnames(df)[which(names(df) == "values.cardsselected")] <- "Trial" #Renames columns to match output of raw IGT data
  colnames(df)[which(names(df) == "response")] <- "Deck"
  colnames(df)[which(names(df) == "values.gain")] <- "Win"
  colnames(df)[which(names(df) == "values.loss")] <- "Lose"
  colnames(df)[which(names(df) == "values.currenttotal")] <- "Score"
  colnames(df)[which(names(df) == "latency")] <- "Time(ms)"
  
  subjIDCol<-which(colnames(df)=="subject") #Creates new name for file to match other CARI naming conventions
  dateCol<-which(colnames(df)=="date")
  subjectID<-df[1,subjIDCol]
  date<-df[1,dateCol]
  outputName<-paste("IGT", subjectID, date, sep="_")
  write.table( df, paste(outputName, ".txt", sep=""),row.names=F, col.names=T, sep = "\t", quote=FALSE) #Saves the processed file, need to move all of these files to a folder with other IGT data
}









# Combining all IGT data --------------------------------------------------
importFunction1<-function(df){ #This function describes what to do if the IGT file has the IGT description in place
  fileName<-str_replace_all(tmpFile, fixed("_"), "-") #Replaces all _ with - to maintain consistency in filename
  dashLocation<-lapply(strsplit(fileName, ''), function(fileName) which(fileName == '-')) #Gets location of every dash in the file name
  dashLocation<-unlist(dashLocation) #Converts the list of locations into extractable info
  txtLocation<-lapply(strsplit(fileName, ''), function(fileName) which(fileName == '.')) #Gets location of .txt in file name
  txtLocation<-unlist(txtLocation) #Converts the list into extractable info
  
  if(length(dashLocation)==1){ #This is for subjects who do not have a date in the filename.
    subjID=substring(fileName, (dashLocation[1]+1), (txtLocation[1]-1)) #Gets the date from filename using period as reference
    date=NA
  }else{
    subjID = substring(fileName, (dashLocation[1]+1),(dashLocation[2]-1))  # gets subject ID from filename using dashes as references
    date=substring(fileName, (dashLocation[2]+1), (txtLocation[1]-1)) #Gets the date from filename using period as reference  
  }
  
  
  df = cbind( df, subjID)  # add a col. with subjID
  colnames(df)[which(names(df) == "subjID")] <- "subject" #Renames subjectID column to match other files
  df = cbind( df, date)  # add a col. with date
  df$Borrow<-NULL #Removes borrow column since it is not in some of the raw data
  df$Deck = gsub("A'", 1, df$Deck) #Replaces default values to match other database
  df$Deck = gsub("B'", 2, df$Deck)
  df$Deck = gsub("C'", 3, df$Deck)
  df$Deck = gsub("D'", 4, df$Deck)
  df$Origin = "Old_IGT"
  
  
  return(df)
}

importFunction2<-function(df){
  df$Lose<-df$Lose*-1 #Makes all the lose values negative
  df$Deck = gsub("deck1", 1, df$Deck) #Replaces default values to match other database
  df$Deck = gsub("deck2", 2, df$Deck)
  df$Deck = gsub("deck3", 3, df$Deck)
  df$Deck = gsub("deck4", 4, df$Deck)
  df$Origin = "IQDAT_IGT"
  return(df)
}


setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/IGT_Combined" ) #Sets working directory to folder where the IQDAT files are
allData = NULL #Dataset where all merged IGT data will be placed
#groupInfo = logData 
allFiles = dir() #Gets directory of all files
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  #subjIdx=1
  tmpFile = allFiles[ subjIdx ]
  message(tmpFile)
  tmp= read.table(tmpFile, skip=21, header=T) #Imports file assuming IGT description is in place
  
  if(nrow(tmp)==100){ #If the file contains IGT description, imports this
    df<-importFunction1(tmp)
  }
  if(nrow(tmp)==79){ #If the file does not contain IGT description, imports like this
    tmp= read.table(tmpFile, header=T,  colClasses=c(date="character", subject="character"))
    df<-importFunction2(tmp)
  }
  if( nrow(tmp)!=100 & nrow(tmp)!=79 ){
    message(paste("THIS FILE IS CORRUPTED PLEASE CHECK MANUALLY ", tmpFile))
  }
  #Renames columns to match requirements for computational modeling
  colnames(df)[which(names(df) == "Trial")] <- "trial"
  colnames(df)[which(names(df) == "Deck")] <- "choice"
  colnames(df)[which(names(df) == "Win")] <- "gain"
  colnames(df)[which(names(df) == "Lose")] <- "loss"
  
  #This is for if there is a master database
  #tmpLog = subset( groupInfo, PRE_1_SUBJ==subjID)  # find this subject's group membership using PRE_1_SUBJ from SPSS file
  #tmpDx = tmpLog[,"PRE_GROUP"]  # 0, 1, 2 for group memebership
  #tmpDx1 = tmpLog[,"PRE_10_GENDER"]  # 0, 1, 2 for gender
  #df = cbind( df, tmpDx, tmpDx1) #Adds column with group membership
  
  #Combines the prepared filesets
  allData = rbind(allData, df) 
 
}

#Preparing output for all data
write.table( allData, "IGT_Combined.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
