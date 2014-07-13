#! /bin/bash
while ./main.sh; do
	echo -e "\e[95mRestart after 5 seconds...\e[0m"
	sleep 5
done
exit
