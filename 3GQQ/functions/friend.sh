# Fetch friend list
function updateFriends
{
	echo -e "\e[96mUpdating friend list...\e[0m"
	friends=
	# Fetch friend list
	url="$(getLinkAddr "$data" "好友列表")"
	tmp="$(getData "$url" "$cookies")"
	url="$(getLinkAddr "$tmp" "分组" | uniq)"
	tmp="$(getData "$url" "$cookies")"
	tmp="$(getSection "$tmp" "anchor" "我的好友(.*")"
	cnt="$(($(echo "$tmp" | wc -l) / 9))"
	for ((i = 1; i < cnt + 1; i++)); do
		# Extract group information
		group="$(echo "$tmp" | head -n $((9 * i)) | tail -n 9)"
		url="$(getFieldArg "$group" go href)"
		group="$(getPostData "$group")"
		group="$(getData "$url" "$cookies" "$group" | stripWhiteSpace | tr -d '\n' | \
			sed "s/^.*<anchor>.*\"我的好友\".*<\/anchor><br\/>\(.*\)<br\/><anchor>.*\"我的好友\".*<\/anchor>.*\$/\1/;s/<br\/>/\n/g")"
		while read tmp; do
			url="$(getArg "$tmp" href)"
			uid="$(getURLArg "$url" u)"
			name="$(echo "$tmp" | sed "s/<[^>]*>//g")"
			friends="$(echo -e "$uid\n$name\n$friends")"
		done <<-FRIENDS_HERE
			$group
		FRIENDS_HERE
	done
	echo -e "\e[96mFriend list updated.\e[0m"
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
	echo "Total: $(($(echo "$friends" | wc -l) / 2)) friends."
}

# Send to friend
function sendToFriend
{
	if [ -z "$friends" ]; then echo "Empty friend list!"; return; fi
	dest="${1/% */}"
	send="${1/#"$dest "/}"
	while read uid; do
		read name
		if [ "$uid" != "$dest" ] && [ -z "$(echo "$name" | egrep "$dest")" ]; then continue; fi
		echo -e "\e[96mMatched: $name($uid)\e[0m" >&2
		sendMsg "$uid" "$send" && echo "Message sent to $name($uid)."
	done <<-FRIENDS_HERE
		$friends
	FRIENDS_HERE
}

# Send to arbitrary QQ account
function sendToQQ
{
	uid="${1/% */}"
	send="${1/#"$uid "/}"
	sendMsg "$uid" "$send" && echo "Message sent to $uid."
}
