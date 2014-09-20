function op
{
	if ((welcomemsg)); then echo "Hello, $sender(op)!"; fi
	opEntry
}

function opEntry
{
	opfunc
	entry
}

function opfunc
{
	if [ "${context:0:1}" == "#" ]; then
		eval "${context:1}" 2>&1
		echo "Command executed."
		exit 0
	elif [ "${context:0:1}" == "@" ]; then
		case "${context:1}" in
		"terminate" | "kill" ) echo "Terminate."
			echo "terminate" >> "$cmdfile";;
		"update" ) echo "Update friend list."
			echo "updateFriends" >> "$cmdfile";;
		"list" ) listFriends;;
		"send "* ) sendToFriend "${context:6}";;
		"send-qq "* ) sendToQQ "${context:9}";;
		* ) return;;
		esac
	else
		case "$context" in
		"help" | "--help" | "-h" | "Help" ) cat "$optext/help-op.txt";;
		* ) return;;
		esac
	fi
	exit 0
}
