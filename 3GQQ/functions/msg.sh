# Accept friend request
function acceptRequest
{
	post=$(getSection "$data" "anchor" "通过并加对方为好友")
	url=$(getFieldArg "$post" go href)
	post=$(getPostData "$post")
	data=$(getData "$url" "$cookies" "$post")
	if [ ! -z "$(echo $data | fgrep "请输入验证信息")" ]; then
		verify="$friendverify"
		post=$(getSection "$data" "anchor" "发送")
		url=$(getFieldArg "$post" go href)
		post=$(getPostData "$post")
	fi
	failed=0
	while ((failed++ < retry)); do
		data=$(getData "$url" "$cookies" "$post")
		echo "$data" > "$debugfile"
		if [ -z "$(echo "$data" | fgrep "失败")" ]; then
			echo -e "\e[92mFriend request accepted!\e[0m"
			return
		fi
		echo -e "\e[93mFriend request failed, retry: $failed...\e[0m"
		#url="$(getLinkAddr "$data" "点此返回重发")"
		#getData "$url" "$cookies" "$post"
		sleep 1
	done
}

# Deny friend request
function denyRequest
{
	post=$(getSection "$data" "anchor" "拒绝")
	url=$(getFieldArg "$post" go href)
	post=$(getPostData "$post")
	echo -e "\e[96m$url, $post\e[0m"
	data=$(getData "$url" "$cookies" "$post")
	echo -e "\e[91mFriend request denied!\e[0m"
}

# Send message to specific QQ account
function sendMsg
{
	uid="$1"
	send="$2"
	replydata="$(sed "s/\$sid/$sid/;s/\$uid/$uid/" "$sendfile")"
	if [ -z "$replydata" ]; then
		echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mFailed to fetch reply data.\e[0m" >&2
		return 1
	fi
	url=$(getFieldArg "$replydata" go href)
#	while read rawmsg; do
#	rawmsg="$send"
		if [ -z "$send" ]; then continue; fi
		failed=0
		msg=$(echo "$send" | text2html | tr -d '\n')
		post=$(getPostData "$replydata")
		while ((failed++ < retry)); do
			data=$(getData "$url" "$cookies" "$post")
			if [ "$(getFieldArg "$data" card title)" == "服务器错误" ]; then
				echo -e "\e[33m$send\e[0m" >&2
				break
			fi
			if [ ! -z "$(echo "$data" | fgrep "消息发送成功")" ]; then
				echo -e "\e[93m$send\e[0m" >&2
				break
			fi
			echo "$data" > "$debugfile"
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mretry $failed...\e[0m" >&2
			if [ ! -z "$(echo "$data" | fgrep "请求过于频繁")" ]; then sleep 8; fi
		done
#	done <<-MESSAGES_HERE
#		$send
#	MESSAGES_HERE
}

# Send reply
function sendReply
{
	pid="$(<"$fifofile")"
	touch "$piddir"/$pid
	reply="$($op)"
	sendMsg "$uid" "$startnote$reply$finishnote"
	rm "$piddir"/$pid
}

# Message handle
function msgHandle
{
	msgcount=$(($(echo "$msgdata" | wc -l) / 3))
	#echo -e "\e[93mGot $msgcount messages.\e[0m"
	for ((i = 1; i < $msgcount + 1; i++)); do
		# Extract message information
		msg="$(echo "$msgdata" | head -n $((3 * i)) | tail -n 3)"
		context=$(echo -n "$msg" | tail -n 1 | html2text)
		sender=$(echo -n "$msg" | head -n 1 | sed "s/: \&nbsp\;\s*\$//")
		time=$(echo -n "$msg" | head -n 2 | tail -n 1 | sed "s/\([0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\).*\$/\1/")
		echo -e "\e[91m$sender\e[97m@\e[94m$time\e[97m: \e[92m$context\e[0m" | iconv -f UTF-8 -t "$encoding"
		context=$(echo -e "$context")

		# Add friend request
		if [ ! -z "$(echo "$data" | fgrep "[请求身份验证]")" ] && [ "$(echo $sender | xargs)" == "10000" ]; then
			if ((addfriend)); then acceptRequest; else denyRequest; fi
			echo "$data" > "$debugfile"
			return;
		fi

		# General message
		replydata=$(getSection "$data" "anchor" "发送QQ消息")
		if [ -z "$replydata" ]; then
			replydata=$(getSection "$data" "anchor" "发送")
		fi
		if [ -z "$replydata" ]; then
			echo "$data" > "$debugfile"
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mFailed to fetch reply data.\e[0m"
			continue
		fi
		uid="$(getArg "$(echo "$replydata" | fgrep "name=\"u\"")" value)"
		echo -e "$replydata" | sed "s/$sid/\$sid/;s/$uid/\$uid/" > "$sendfile"

		mkfifo "$fifofile"
		(sendReply) &
		sleep 1
		echo "$!" > "$fifofile"
		rm "$fifofile"
	done
	((msgcount >= 3)) && sendMsg "$uid" "You send messages too fast! Please be slower, otherwise messages may become disordered."
}
