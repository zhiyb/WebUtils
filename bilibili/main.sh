#! /bin/bash

# Load functions
. ./functions/wget.sh
. ./functions/text.sh

function getLists
{
	url="http://www.bilibili.com/video/$av"
	echo -e "\e[94mAnalysing $url...\e[0m"
	data=$(getGZIPData "$url")
	name=$(echo "$data" | fgrep '<h2 title' | sed "s/<[^>]*>//g" | stripWhiteSpace)
	mkdir -p "$dir/$(echo "$name" | fileName)"
	data=$(echo "$data" | getSection select dedepagetitles)
	list=$(echo "$data" | egrep '^[^<]' | sed "s/^/\"/;s/\$/\"/")
	eval namelist=($list)
	url="http:\/\/www.bilibili.com"
	urllist=($(echo "$data" | getFieldArg option value | sed "s/^/$url/"))
	echo -e "\e[37m$name \e[94mGot \e[97m${#namelist[@]}\e[94m items.\e[0m"
}

function download
{
	for ((i = 0; i < ${#namelist[@]}; i++)); do
		downloadThread "${namelist[i]}" "${urllist[i]}"
	done
}

# Args: Name, URL
function downloadThread
{
	while :; do
		#echo -e "\e[93mDownloading \e[37m$1\e[93m: $2...\e[0m"
		url=$(getWData "http://www.flvcd.com/parse.php?kw=$2" | iconv -f GB2312 -t "$encoding" | fgrep "下载地址" | sed "s/</\n</g;s/>/>\n/g" | getFieldArg a href)
		file="$dir/$(echo "$name" | fileName)/$(echo "$1.flv" | fileName)"
		#[ -e "$file" ] && echo -e "\e[93mSkip \e[37m$1\e[0m" && continue
		echo -e "\e[93mDownloading \e[37m$1\e[0m"
		wget --progress=bar:force -c -O "$file" "$url" 2>&1 | progressFilter && return
#		wget --progress=bar:force --user-agent="$agent" -c -O "$file" "$url" 2>&1 && return
	done
}

# Files
export conffile="conf.txt"

# Configuration variables
encoding="UTF-8"
#agent="Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0;  rv:11.0) like Gecko"
#agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"

[ ! -e "$conffile" ] && echo "Error: no $conffile" && exit 1
. $conffile

[ -z "$av" ] && echo "Error: no av number imported" && exit 1

getLists
download
exit
