# Args: URL Cookies Post
function getData
{
	#	-t 5 -T 5
	wget --dns-timeout=1 --connect-timeout=6 --read-timeout=15 --wait=0 --tries=3 --no-cache -qO - --post-data="$3" "$1" #--keep-session-cookies --load-cookies="$2" --save-cookies="$2"
}

# Args: URL Cookies Post
function getDataNoSave
{
	#	-t 5 -T 5
	getData $@
	#wget --dns-timeout=1 --connect-timeout=5 --wait=0 --tries=3 --no-cache -qO - --post-data="$3" "$1" #--load-cookies="$2"
}
