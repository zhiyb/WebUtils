#! /bin/bash

function download
{
	mkdir -p "$(dirname "$2")"
	wget --load-cookies="$cookies" -c "$1" -O "$2"
}

cookies="$1"

while read line; do
	eval download $line
done
