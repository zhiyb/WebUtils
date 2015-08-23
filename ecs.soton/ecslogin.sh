#! /bin/bash
echo "Username:"
read username
echo "Password:"
read -s password
cookies="$username.cookies"
wget="wget -qO - --keep-session-cookies --load-cookies=$cookies --save-cookies=$cookies"
post="--post-data=ecslogin_username=${username}&ecslogin_password=${password}&ecslogin_security=weak&ecslogin_uri=/&ecslogin_args="
$wget https://secure.ecs.soton.ac.uk/ | fgrep 'Logged in as' | sed 's/|.*$//;s/<[^>]*>//g'
$wget https://secure.ecs.soton.ac.uk/logout/ > /dev/null
$wget $post https://secure.ecs.soton.ac.uk/login/now/index.php | fgrep 'Logged in as' | sed 's/|.*$//;s/<[^>]*>//g'
$wget $post https://secure.ecs.soton.ac.uk/login/now/index.php | fgrep 'Logged in as' | sed 's/|.*$//;s/<[^>]*>//g'
exit
