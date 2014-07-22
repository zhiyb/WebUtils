function normal
{
	if ((welcomemsg)); then echo "Hello, $sender!"; fi
	func
}

function entry
{
	func
}

function help
{
	echo "Use @keyword to run specific task.
	Available tasks:
	@status / @info		| Display current status
	@date			| Display date
	@time			| Display time
	@datetime		| Display date and time"
}

function func
{
	if [ "${context:0:1}" == "@" ]; then
		case "${context:1}" in
		"date" ) date '+%Y-%m-%d';;
		"time" ) date '+%H:%M:%S';;
		"status" | "info" ) status;;
		"datetime" ) date '+%Y-%m-%d %H:%M:%S';;
		* ) echo "Unknown instruction!";;
		esac
	else
		case "$context" in
		*help* | *Help* | "帮助" ) help;;
		"Hello" | "hello" | "你好" ) echo "Hello, this is the AUTO script.";;
		zyh*笨蛋* ) echo "对的对的喵~不要告诉他喵~";;
		* ) 
			echo "Hello, this is the AUTO script.
		Admin is zhiyb @ 544080857.
		For help, say \`help\'.";;
		esac
	fi
	exit 0
}

function status
{
	now=$(date +%s)
	echo "$(date -d "@$starttime" '+S: %Y-%m-%d %H:%M:%S'), $(date -d "@$logintime" '+L: %Y-%m-%d %H:%M:%S'), $(date -d "@$now" '+N: %Y-%m-%d %H:%M:%S'), "
	elapsed=$(printf "%.0F" $(echo "$now - $logintime" | bc))
	printf "Duration: %02d:%02d:%02d, " $((elapsed / 3600)) $((elapsed / 60 % 60)) $((elapsed % 60))
	elapsed=$(printf "%.0F" $(echo "$now - $starttime" | bc))
	printf "Elapsed: %02d:%02d:%02d, \n" $((elapsed / 3600)) $((elapsed / 60 % 60)) $((elapsed % 60))
	echo -e "QQ number: $qq, Refresh speed: $sleep"
}
