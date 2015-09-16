#### Install missing packages
# install packages
req_pkgs=c(
	'data.table',
	'stringr',
	'twitteR',
	'streamR'
)
miss_pkgs=setdiff(req_pkgs, installed.packages()[,"Package"])
if (length(miss_pkgs)>0)
	install.packages(miss_pkgs)


