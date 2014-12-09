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
		"r" ) remote 1;;
		"rinfo" ) remote 2;;
		"killr" ) remote 0;;
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

function checkRemote
{
	ps w | grep "ssh .* yz39g13@uglogin" | grep -v "grep" | awk "{print(\$1)}"
}

function remote
{
	if (($1 == 1)); then
		echo "ssh -i /root/.ssh/id_rsa yz39g13@uglogin.ecs.soton.ac.uk -N -R 2222:127.0.0.1:22 -R 59590:192.168.0.6:5900 &" >> "$cmdfile"
		chmod 755 "$cmdfile"
		echo "SSH remote launched."
		exit 1
	elif (($1 == 0)); then
		id=$(checkRemote)
		if [ "$id" == "" ]; then
			echo "No SSH remote running."
		elif kill $id 2>&1; then
			echo -e "SSH remote killed:\n$id"
		fi
	else
		id=$(checkRemote)
		if [ "$id" == "" ]; then
			echo "No SSH remote running."
		else
			echo -e "SSH remote running:\n$id"
		fi
	fi
}
