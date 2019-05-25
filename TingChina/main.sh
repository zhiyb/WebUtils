#! /bin/bash

# Load functions
. ./functions/wget.sh
. ./functions/text.sh

function getLists
{
	echo -e "\e[94mAnalysing $url...\e[0m"
	data=$(getWData "$url" | codec GB2312 "$encoding")
	name=$(echo "$data" | fgrep '<title>' | sed "s/<[^>]*\>>//g" | stripWhiteSpace)
	data=$(echo "$data" | fgrep '<li class="play_dirli">' | fgrep '/down_' | sed 's/>/>\n/g;s/</\n</g')
	namelist=($(echo "$data" | egrep '第[0-9]+回'))
	urllist=($(echo "$data" | fgrep '<a href="' | getArg 'href'))
	echo -e "\e[37m$name \e[94mGot \e[97m${#namelist[@]}\e[94m items.\e[0m"
}

function download
{
	for ((i = 0; i < ${#namelist[@]}; i++)); do
		((from > i + 1)) && continue
		downloadThread "${namelist[i]}" "${urllist[i]}"
	done
}

# Args: Name, URL
function downloadThread
{
	while :; do
		echo -e "\e[93mDownloading \e[37m$1\e[93m: $2...\e[0m"
		data=$(getWData "$2" | codec GB2312 "$encoding" | egrep '^\s*url\[[012]\]=')
		part1=$(echo "$data" | fgrep "$network" | sed "s/^.*\"\([^\"]*\)\".*/\1/")
		part2=$(echo "$data" | fgrep "url[2]" | sed "s/^.*\"\([^\"]*\)\".*/\1/")
		url="$part1$part2"
		file=$(echo "$url" | sed "s/^.*\/\([^\/]*\)?key.*\$/\1/")
		dir=$(echo "$url" | sed "s/^.*\/\([^\/]*\)\/[^\/]*\$/\1/")

		mkdir -p "$dir"
		wget -t 1 -qO "$dir/$file" "$url"
		[ $? == 0 ] && echo -e "\e[37m$(date '+%Y-%m-%d %H:%M:%S') \e[92mFinished: \e[97m$dir/$file\e[0m" && break
		echo -e "\e[37m$(date '+%Y-%m-%d %H:%M:%S') \e[91mDownload failed, retry...\e[0m"
	done
}

# Files
export conffile="conf.txt"

# Configuration variables
encoding="UTF-8"

[ ! -e "$conffile" ] && echo "Error: no $conffile" && exit
. $conffile

getLists
download
exit
