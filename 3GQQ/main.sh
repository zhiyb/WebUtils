#! /bin/bash

# Load functions
function update
{
	. ./functions/wget.sh
	. ./functions/text.sh
	. ./functions/msg.sh
	. ./functions/login.sh
	. ./functions/loop.sh
	. ./functions/friend.sh
}
update

# Function to terminate all sub processes
function terminate
{
	echo -e "\e[91mTerminating...\e[0m"
	if [ -d "$piddir" ]; then
		kill $(ls -1 "$piddir" | xargs) > /dev/null 2>&1
		rm -rf "$piddir"
	fi
	mkdir -p "$piddir"
	#: > "$fifopidfile"
}

# Function to terminate all sub processes and quit, provide for convince
function quit
{
	terminate
	exit $@
}

# Files
export cachedir="./cache"
export piddir="./cache/pid"
#export fifodir="$cachedir/fifo"
export op="./op.sh"
export img="./bin/ImageViewer"
export urlfile="./conf/url.txt"
export sendfile="./conf/send.txt"
export conffile="./conf/conf.txt"
export cookies="$cachedir/cookies.txt"
export imgfile="$cachedir/image.png"
export debugfile="$cachedir/error.log"
export cmdfile="$cachedir/cmd.sh"
export fifofile="$cachedir/fifo.tmp"
#export fifofile="$fifodir/tmp"
#export fifopidfile="$fifodir/pid"
mkdir -p conf cache "$piddir" "$cachedir"
: > "$cmdfile"

# Configuration variables
export starttime=$(date +%s)
export sleep=3
export encoding="UTF-8"
export welcomemsg=1
export addfriend=0
export startNote=
export finishNote=
export friendverify="Verify message not defined."
export loginType=1
export imgType=png
export retry=10
export admin=
export reportInit=1
export reportRecovery=0
export reportMessage=1
export startupUpdate=1
export tooFast=1

# Program variables
export pattern="聊天"
export patternA="提示<\/a>"
export patternB="<input name=\"msg\""
export failed=0
#export fifocreated=0
export sender context time replydata url post uid friends sid qq
if [ -e "$urlfile" ]; then
	refresh=$(<"$urlfile")
fi
if [ -e "$conffile" ]; then
	. $conffile
fi

# Setup traps for signal handling
trap "echo -e \"\e[91mShutting down...\e[0m\"; wait; exit" EXIT

# Get refresh address & session id
if [ ! -z "$refresh" ]; then
	echo -e "\e[97mUsing saved sid\e[0m"
	export logintime=$(date +%s)
else
	login
fi
sid=$(getURLArg "$refresh" sid)

# Setup traps for signal handling
trap quit SIGINT

# Execute main loop
messageLoop
exit
