#### Initialise twitter connection
# initialise twitter connection
oauth=readRDS('data/credentials/twitter.rda')
original_ooption <- options("httr_oauth_cache")
options(httr_oauth_cache=TRUE)
setup_twitter_oauth(oauth$api_key, oauth$api_secret, oauth$access_token, oauth$access_token_secret)
options(httr_oauth_cache=original_ooption)

# check twitter connection
twitteR:::check_twitter_oauth()

#### Define functions
download_user_timeline=function(usr, outputDIR, overwrite=FALSE) {
	cat('starting user',usr,'\n')
	currExpPTH=paste0(outputDIR,'/',usr,'.rds')
	if (!file.exists(currExpPTH) || overwrite) {
		# download timeline
		cat('\tdownloading timeline\n')
		usrTL=list()
		counter=0
		counter2=0
		lastId=NULL
		while(TRUE) {
			# ini
			counter=counter+1
			cat("\t\tstarting batch",counter,"\n")

			# download data
			currT=try(userTimeline(usr, n=200, includeRts=FALSE, maxID=lastId), silent=TRUE)
			if (!inherits(currT, 'try-error')) {
				# if no partial results returned then store results and start next batch
				counter2=counter2+1
				usrTL[[counter2]]=currT
				usrTL[[counter2]]=usrTL[[counter2]][-length(usrTL[[counter2]])]
				cat("\t\t\tdownloaded",length(usrTL[[counter2]]),"tweets\n")
				# start next batch
					if (length(usrTL[[counter2]])==0)
						break
					lastId=usrTL[[counter2]][[length(usrTL[[counter2]])]]$id
					if (counter2>1) {
						if (usrTL[[counter2]][[length(usrTL[[counter2]])]]$id == usrTL[[counter2-1]][[length(usrTL[[counter2-1]])]]$id) {
							break
						}
					}
			} else {
				# sleep for a while and try again
				cat('\t\t\tlimit reached sleeping\n')
				Sys.sleep(100)
			}
		}
		usrTL=unlist(usrTL, recursive=FALSE, use.names=FALSE)

		# generate data.frame
		cat('\tsanitsing strings\n')
		expDF=twListToDF(usrTL)
		expDF=expDF[which(!expDF$isRetweet),]
		expDF$text=gsub("'", "", expDF$text)
		expDF$text=gsub('"', '', expDF$text)
		
		# save data
		saveRDS(expDF, currExpPTH)
	} else {
		expDF=readRDS(currExpPTH)
	}
	
	# return results
	return(expDF)
}

download_retweets=function(id, outputDIR, overwrite=FALSE) {
# 	cat('starting tweet',id,'\n')
	currExpPTH=paste0(outputDIR,'/',id,'.rds')
	if (!file.exists(currExpPTH) || overwrite) {
		# download timeline
		while(TRUE) {
			# download data
			currTweetDF=try(retweets(id, n=100), silent=TRUE)
			if (!inherits(currTweetDF, 'try-error')) {
				# if no partial results returned then store results and start next batch
# 				cat("\t\t\tdownloaded",nrow(currTweetDF),"tweets\n")
				break
			} else {
				# sleep for a while and try again
				cat('\t\t\tlimit reached sleeping\n')
				Sys.sleep(100)
			}
		}
		
		# generate data.frame
# 		cat('\tsanitsing strings\n')
		expDF=twListToDF(currTweetDF)
		expDF$text=gsub("'", "", expDF$text)
		expDF$text=gsub('"', '', expDF$text)
		
		# save data
		saveRDS(expDF, currExpPTH)
	} else {
		expDF=readRDS(currExpPTH)
	}
	
	# return results
	return(TRUE)
}
 

download_retweeters=function(id, outputDIR, overwrite=FALSE) {
# 	cat('starting tweet',id,'\n')
	currExpPTH=paste0(outputDIR,'/',id,'.rds')
	if (!file.exists(currExpPTH) || overwrite) {
		# download retweeters
		retweetersCHR=c()
		while(TRUE) {
			# download data
			retweetersCHR=suppressWarnings(try(retweeters(id, n=1000), silent=TRUE))
			if (!inherits(retweetersCHR, 'try-error') & length(retweetersCHR)>0) {
				# if no partial results returned then store results and start next batch
				break
			} else {
				# sleep for a while and try again
				cat('\t\t\tlimit reached sleeping\n')
				Sys.sleep(100)
			}
		}
		
		# save data
		saveRDS(retweetersCHR, currExpPTH)
	} else {
		expDF=readRDS(currExpPTH)
	}
	# return results
	return(TRUE)
}



download_followers=function(id, outputDIR, overwrite=FALSE) {
	usrObj=getUser(id)
	currExpPTH=paste0(outputDIR,'/',id,'.rds')
	if (!file.exists(currExpPTH) || overwrite) {
		# download retweeters
		followersCHR=c()
		while(TRUE) {
			# download data
			followersCHR=suppressWarnings(try(retweeters(id, n=1000), silent=TRUE))
			if (!inherits(followersCHR, 'try-error') & length(followersCHR)>0) {
				# if no partial results returned then store results and start next batch
				break
			} else {
				# sleep for a while and try again
				cat('\t\t\tlimit reached sleeping\n')
				Sys.sleep(100)
			}
		}
		
		# save data
		saveRDS(followersCHR, currExpPTH)
	} else {
		expDF=readRDS(currExpPTH)
	}
	# return results
	return(TRUE)
}