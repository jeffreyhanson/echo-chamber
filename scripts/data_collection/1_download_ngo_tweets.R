#### Initialization
# set R parameters
rm(list=ls())
options(stringsAsFactors=FALSE)
setwd(file.path(Sys.getenv('HOME'), 'github', 'echo-chamber'))
source('')

# set system parameters
inpPTH='data/raw_data/ngo_handles.csv'
expDIR='/home/jeff/GitHub/echo-chamber/data/tweets/ngo'

# load deps
library(magrittr)
library(plyr)
library(dplyr)
library(data.table)
library(twitteR)

# define functions
test=function() {source('/home/jeff/GitHub/echo-chamber/scripts/data_collection/1_download_ngo_tweets.R')}

#### Preliminary processing
# load data
ngoDF=fread(inpDF)

#### Main processing
ret=laply(ngoDF[[1]], .progress='text', .fun=function(x)) {
	






}
