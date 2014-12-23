# Login
function login
{
	echo -e "\e[97mPreparing login process...\e[0m"
	rm -f "$cookies"
	url='3g.qq.com'
	data=$(getData "$url" "$cookies")
	url=$(getFieldArg "$data" card ontimer)
	data=$(getData "$url" "$cookies")
	loginurl=$(getLinkAddr "$data" "ＱＱ")
	sid=$(getURLArg "$loginurl" sid)

	# Need verify?
	while :; do
		echo -ne "\e[94mQQ account: $qq"
		if [ -z $qq ]; then read qq; else echo; fi
		echo -ne "Password: "
		if [ -z $pwd ]; then read -s pwd; fi
		pwd=$(echo "$pwd" | text2html)
		echo -e "\n\e[97mLogging in...\e[0m"
		data=$(getData "$loginurl" "$cookies")
		data=$(getSection "$data" "anchor" "马上登录")
		url=$(getFieldArg "$data" go href)
		data="$(getPostData "$data")&imgType=$imgType"
		data=$(getData "$url" "$cookies" "$data")
		if [ ! -z "$(echo "$data" | fgrep "验证码")" ]; then
			wget -qO "$imgfile" $(getImageAddr "$data" "验证码")
			echo -ne "\e[94mImage verify required: "
			$img "$imgfile" > /dev/null 2>&1 &
			read verify
			killall $(basename "$img")
			echo -e "\e[97mLogging in...\e[0m"
			data=$(getSection "$data" "anchor" "马上登录")
			url=$(getFieldArg "$data" go href)
			data=$(getPostData "$data")
			data=$(getData "$url" "$cookies" "$data")
		fi
		if [ "$(getFieldArg "$data" card title)" == "登录成功" ]; then break; fi
		echo "$data" > "$debugfile"
		echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mLogin failed, retry...\e[0m"
		unset qq pwd
		. "$conffile"
	done

	echo -e "\e[37mWebsite: 3GQQ\e[0m"
	url=$(getFieldArg "$data" card ontimer)
	data=$(getData "$url" "$cookies")
	refresh=$(getLinkAddr "$data" "$pattern")
	echo -n "$refresh" > "$urlfile"
	export logintime=$(date +%s)
	fifocreated=0
}

# For sid relogin
function relogin
{
	url="http://pt.3g.qq.com/s?aid=nLogin3gqqbysid&sid=$sid"
	getData "$url" "$cookies" "auto=1&loginType=$loginType&3gqqsid=$sid"
	export logintime=$(date +%s)
}
