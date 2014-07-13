# Args: URL Cookies Post
function getData
{
	#	-t 5 -T 5
	wget -t 0 -T 5 -qO - --post-data="$3" "$1" #--keep-session-cookies --load-cookies="$2" --save-cookies="$2"
}

# Args: URL Cookies Post
function getDataNoSave
{
	#	-t 5 -T 5
	wget -t 0 -T 5 -qO - --post-data="$3" "$1" #--load-cookies="$2"
}
