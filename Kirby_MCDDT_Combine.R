rm(list=ls())
library(foreign)
library(stringr)
library(filesstrings)


# Combining all Delay Discounting data --------------------------------------------------
setwd( "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby" ) #Sets working directory to folder where the IQDAT files are
allCombined = NULL #Dataset where the files containing ALL will be placed
allFiles = dir() #Gets directory of all files
numSubjs = length( allFiles )
for (subjIdx in 1:numSubjs) {
  #subjIdx=1
  tmpFile = allFiles[ subjIdx ]
  df= read.table(tmpFile, skip=13, sep=",", header = F) #Imports file assuming IGT description is in place
  
  
  #Error checking to make sure the files are complete, if they are not complete they are moved to a different folder and skipped
  if( (nrow(df)!=27 )) {
    file.move(paste("C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby", tmpFile, sep = "/"), "C:/Users/shahidir/Dropbox/Research/Data Processing/Raw Data/Kirby Incomplete")
    next
  }
  #Completes the merging of the files
  allCombined = rbind(allCombined, df) 
}

colnames(allCombined)[which(names(allCombined) == "V1")] <- "subject_id" 
colnames(allCombined)[which(names(allCombined) == "V2")] <- "trial" 
colnames(allCombined)[which(names(allCombined) == "V3")] <- "question" 
#colnames(allCombined)[which(names(allCombined) == "V4")] <- "reward_reality" 
#colnames(allCombined)[which(names(allCombined) == "V5")] <- "gain_or_losses" 
#colnames(allCombined)[which(names(allCombined) == "V6")] <- "trial_number" 
#colnames(allCombined)[which(names(allCombined) == "V7")] <- "amount" 


#Outputing all data
write.table( allCombined, "Kirby_Combined.txt",row.names=F, col.names=T, sep = "\t", quote=FALSE  )
