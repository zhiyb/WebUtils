# Args: URL
function getWData
{
	wget -qO - "$1"
}

# Args: URL
function getGZIPData
{
	wget -qO - "$1" | gzip -d
}

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

# http://stackoverflow.com/questions/4686464/howto-show-wget-progress-bar-only
# Args:
function progressFilter
{
	local flag=false c count cr=$'\r' nl=$'\n'
	while IFS='' read -d '' -rn 1 c
	do
		if $flag
		then
			#printf '%c' "$c"
			echo -n "$c"
		else
			if [[ $c != $cr && $c != $nl ]]
			then
				count=0
			else
				((count++))
				if ((count > 1))
				then
					flag=true
				fi
			fi
		fi
	done
}
