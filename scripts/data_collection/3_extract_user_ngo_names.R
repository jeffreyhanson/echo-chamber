 
#### Initialization
# set R parameters
rm(list=ls())
options(stringsAsFactors=FALSE)
setwd('/home/jeff/GitHub/echo-chamber/')

# set system parameters
inpDIR='data/twitter_data/retweeters'
expPTH='data/raw_data/ngos_and_user_ids.csv'

# load deps
library(magrittr)
library(plyr)
library(dplyr)
library(rgdal)
library(data.table)

# define functions
test=function() {source('/home/jeff/GitHub/echo-chamber/scripts/data_collection/3_extract_user_ngo_names.R')}

#### Preliminary processing
# load twitter handles
ngoDF=fread('data/raw_data/ngo_handles.csv')
ngoDF$id=llply(ngoDF[[1]], .fun=function(x) {
	return(getUser(x)$id)
	
})
ngoDF$type='ngo'

# get user ids
userDF=data.frame(
	name='unknown',
	id=unlist(llply(dir('data/twitter_data/retweeters', '^.*.rds$', resursive=TRUE, full.names=TRUE), readRDS), recursive=TRUE, use.names=FALSE),
	type='user'
	
)
#### Main processing
# generate export data.frame
expDF=rbind(ngoDF, userDF)

#### Exports
# save exports
write.table(expDF, expPTH, sep=',', row.names=FALSE)

