#! /bin/bash

. ./functions/wget.sh
. ./functions/text.sh
. ./functions/msg.sh
. ./functions/login.sh
. ./functions/loop.sh
. ./functions/friend.sh
. ./op/admin.sh
. ./op/op.sh
. ./op/normal.sh

touch "$piddir"/$$
trap "rm \"$piddir\"/$$" EXIT

case $uid in
# zhiyb
544080857 ) admin;;
# PokeBox | zyh001    | Ruilx
931296415 | 470612348 | 799382072 ) op;;
# Else
* ) normal;;
esac
exit 0
