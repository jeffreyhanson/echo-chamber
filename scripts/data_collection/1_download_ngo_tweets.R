#### Initialization
# set R parameters
rm(list=ls())
options(stringsAsFactors=FALSE)
setwd(file.path(Sys.getenv('HOME'), 'GitHub', 'echo-chamber'))

# set system parameters
inpPTH='data/raw_data/ngo_handles.csv'
expDIR='/home/jeff/GitHub/echo-chamber/data/twitter_data/tweets/ngo/'

# load deps
library(magrittr)
library(plyr)
library(dplyr)
library(data.table)
library(twitteR)
source('scripts/initialization/function_definitions.R')

# define functions
test=function() {source('/home/jeff/GitHub/echo-chamber/scripts/data_collection/1_download_ngo_tweets.R')}

#### Preliminary processing
# load data
ngoDF=fread(inpPTH)

#### Main processing
ret=llply(ngoDF[[1]], .fun=download_user_timeline, outputDIR=expDIR, overwrite=FALSE)


