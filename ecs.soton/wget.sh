#! /bin/bash
wget -qO - --load-cookies="$2" "$1" | sed 's/</\n</g;s/>/>\n/g' | fgrep -i 'href=' | sed 's/^.*href="//;s/".*$//' | egrep -vi 'https*\:\/\/' | fgrep -v 'mailto:' | grep '^[a-zA-Z0-9]' | sed 's/%20/ /g' | while read line; do
	if [ "${line:(-1)}" == "/" ]; then
		dir="$line"
		mkdir -p "$dir"
		(cd "$dir"; "$0" "$1/$dir" "../$2")
		continue
	fi
	dir="$(dirname "$line")"
	if [ ! -e "$dir" ]; then
		mkdir -p "$dir"
		(cd "$dir"; "$0" "$1/$dir" "../$2")
	fi
	wget --load-cookies="$2" -c "$1/$line" -O "$line" -q
#	echo "$1/$line"
	echo "$line"
done
wget --load-cookies="$2" -c -q "$1" -O index.html
echo "$1"
