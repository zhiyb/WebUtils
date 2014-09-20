function admin
{
	if ((welcomemsg)); then echo "Hello, $sender(admin)!"; fi
	adminEntry
}

function adminEntry
{
	adminfunc
	opEntry
}

function adminhelp
{
	cat "$optext/help-admin.txt"
}

function adminfunc
{
	if [ "${context:0:1}" == "/" ]; then
		echo "${context:1}" >> "$cmdfile"
		chmod 755 "$cmdfile"
		echo "Run by main loop, output not available."
		exit 1
	elif [ "${context:0:1}" == "@" ]; then
		case "${context:1}" in
		"remote" ) remote 1;;
		"killremote" ) remote 0;;
		"quit"* ) echo "Quit."
			echo "${context:1}" > "$cmdfile";;
		"exit"* ) echo "Exit."
			echo "${context:1}" > "$cmdfile";;
		* ) return;;
		esac
	else
		case "$context" in
		"help" | "--help" | "-h" | "Help" ) adminhelp;;
		* ) return;;
		esac
	fi
	exit 0
}

function remote
{
	ip=192.168.6.12
	ip2=192.168.0.24
	if (($1 == 1)); then
		echo "ssh yz39g13@uglogin -R 2222:127.0.0.1:22 -R 59590:$ip:5900 -N -R 59591:$ip2:5900 &" >> "$cmdfile"
		chmod 755 "$cmdfile"
		echo "SSH remote launched."
		exit 1
	else
		id=$(ps xw | grep "ssh yz39g13@uglogin" | grep -v "grep" | awk "{print(\$1)}")
		if [ "$id" == "" ]; then
			echo "No SSH remote running."
		elif kill $id 2>&1; then
			echo "SSH remote killed."
		fi
	fi
}
