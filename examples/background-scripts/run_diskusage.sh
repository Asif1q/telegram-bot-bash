#!/bin/bash
# file: run_diskcusage.sh
# example for an background job display a system value
#
# This file is public domain in the USA and all free countries.
# Elsewhere, consider it to be WTFPLv2. (wtfpl.net/txt/copying)
#### $$VERSION$$ v1.0-0-g99217c4

######
# parameters
# $1 $2 args as given to starct_proc chat script arg1 arg2
# $3 path to named pipe/log


# adjust your language setting here
# https://github.com/topkecleon/telegram-bot-bash#setting-up-your-environment
export 'LC_ALL=C.UTF-8'
export 'LANG=C.UTF-8'
export 'LANGUAGE=C.UTF-8'

unset IFS
# set -f # if you are paranoid use set -f to disable globbing

# discard STDIN for background jobs!
cat >/dev/null & 

source "./mycommands.sh"

# check if $1 is a number
re='^[0-9]+$'
if [[ $1 =~ $re ]] ; then
	SLEEP="$1"
else
	SLEEP=100 # time between time notifications
fi

NEWLINE=$'\n'

# output disk usgae every $1 seconds
WAIT=0
while sleep $WAIT
do
	output_telegram "Current Disk usage ${NEWLINE} $(df -h / /tmp /usr /var /home)"
	# only for testing, delete echo line for production ...
	echo "Current Disk usage ${NEWLINE} $(df -h / /tmp /usr /var /home)"
	WAIT="$SLEEP"
done

