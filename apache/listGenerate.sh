#! /bin/bash

[ "$#" != 1 ] && echo "Args: URL" && exit 1

# Load functions
. ./functions/wget.sh
. ./functions/text.sh

function getLists
{
	#echo -e "\e[94mAnalysing $url...\e[0m"
	data=$(getWData "$url" | sed '0,/Parent Directory/d' | fgrep '<a href=' | sed "s/.*<a/<a/;s/<\/a.*//")
	urllist=($(echo "$data" | getFieldArg a href | awk "{print \"$url/\"\$0}"))
	list=$(echo "$data" | sed "s/<.*>//g;s/^/\"/;s/$/\"/")
	eval namelist=($list)
	#echo -e "\e[37m$name \e[94mGot \e[97m${#namelist[@]}\e[94m items.\e[0m"
}

function output
{
	for ((i = 0; i < ${#namelist[@]}; i++)); do
		echo "\"${urllist[i]}\" \"${namelist[i]}\""
	done
}

url="$1"
file="$2"

# Configuration variables
encoding="iconv -f UTF-8 -t GB2312"

getLists
output
exit
