#### Initialization
# set R parameters
rm(list=ls())
options(stringsAsFactors=FALSE)
setwd(file.path(Sys.getenv('HOME'), 'GitHub', 'echo-chamber'))

# set program parameters
inpDIR='data/twitter_data/retweeters/ngo'
expDIR='data/twitter_data/retweeters/ngo'

# load deps
library(magrittr)
library(plyr)
library(dplyr)
library(data.table)
library(twitteR)
source('scripts/initialization/function_definitions.R')

# define functions
test=function() {source('/home/jeff/GitHub/echo-chamber/scripts/data_collection/2_download_user_retweets.R')}

#### Preliminary processing
# load file paths
inpPTHS=dir(inpDIR)

#### Main processing
ret=llply(inpPTHS, .progress='text', .fun=function(x) {
	# load data
	currDF=readRDS(file.path(inpDIR, x))
	subDF=filter(currDF, retweetCount > 0)
	currDIR=file.path(expDIR, gsub('.rds', '', x, fixed=TRUE))
	dir.create(currDIR, showWarnings=FALSE)

	# get retweets
	x=llply(as.character(subDF$id), .fun=download_retweeters, outputDIR=currDIR, overwrite=TRUE)
	
	# post
	return(TRUE)

})


 
