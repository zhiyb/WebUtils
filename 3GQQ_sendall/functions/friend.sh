# Fetch friend list
function updateFriends
{
	echo -e "\e[96mUpdating friend list...\e[0m"
	friends=
	# Fetch friend list
	url="$(getLinkAddr "$data" "好友列表")"
	if [ -z "$url" ]; then
		tmp="$data"
	else
		tmp="$(getData "$url" "$cookies")"
	fi
	url="$(getLinkAddr "$tmp" "分组" | uniq)"
	[ -z "$url" ] && echo -e "\e[91mUpdate friend list failed.\e[0m" && return 1
	tmp=
	while :; do
		tmpData="$(getData "$url" "$cookies")"
		tmp="$(echo -e "$tmp\n$(getSection "$tmpData" "anchor" "我的好友(.*")")"
		echo "$tmpData" | fgrep -q "下页" || break;
		url="$(getLinkAddr "$tmpData" "下页")"
	done
	tmp="$(echo "$tmp" | tail -n +2)"
	cnt="$(($(echo "$tmp" | wc -l) / 9))"
	for ((i = 1; i < cnt + 1; i++)); do
		group="$(echo "$tmp" | head -n $((9 * i)) | tail -n 9)"
		while :; do
			# Extract group information
			url="$(getFieldArg "$group" go href)"
			group="$(getPostData "$group")"
			tmpData="$(getData "$url" "$cookies" "$group")"
			group="$(echo "$tmpData" | stripWhiteSpace | tr -d '\n' | sed "s/^.*<anchor>.*\"我的好友\".*<\/anchor><br\/>\(.*\)<br\/><anchor>.*\"我的好友\".*<\/anchor>.*\$/\1/;s/<br\/>/\n/g")"
			while read line; do
				url="$(getArg "$line" href)"
				uid="$(getURLArg "$url" u)"
				name="$(echo "$line" | sed "s/<[^>]*>//g")"
				echo -e "$name($uid)"
				friends="$(echo -e "$uid\n$name\n$friends")"
			done <<-FRIENDS_HERE
				$group
			FRIENDS_HERE
			echo "$tmpData" | fgrep -q "下页" || break;
			group="$(getSection "$tmpData" "anchor" "下页")"
		done
	done
	echo -e "\e[96mFriend list updated.\e[0m"
}

# Count friends
function countFriends
{
	echo "Total: $(($(echo "$friends" | wc -l) / 2)) friends."
}

# List friends
function listFriends
{
	while read uid; do
		read name
		echo "$name($uid)"
	done <<-FRIENDS_HERE
		$friends
	FRIENDS_HERE
	countFriends
	#echo "Total: $(($(echo "$friends" | wc -l) / 2)) friends."
}

# Send to friend
function sendToFriend
{
	if [ -z "$friends" ]; then echo "Empty friend list!"; return; fi
	dest="${1/% */}"
	send="${1/#"$dest "/}"
	matched=0
	while read uid; do
		read name
		if [ "$uid" != "$dest" ] && [ -z "$(echo "$name" | egrep "$dest")" ]; then continue; fi
		matched=1
		echo -e "\e[96mMatched: $name($uid)\e[0m" >&2
		sendMsg "$uid" "$send" && echo "Message sent to $name($uid)."
	done <<-FRIENDS_HERE
		$friends
	FRIENDS_HERE
	((!matched)) && echo "Cannot match $dest"
}

# Send to arbitrary QQ account
function sendToQQ
{
	uid="${1/% */}"
	send="${1/#"$uid "/}"
	sendMsg "$uid" "$send" && echo "Message sent to $uid."
}
