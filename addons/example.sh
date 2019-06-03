#!/bin/bash
# file: addons/example.sh.dist
#
# Addons can register to bashbot events at statup
# by providing their name and a callback per event
#
#### $$VERSION$$ v0.91-0-ge2c998c
#
# If an event occours each registered event function is called.
#
# Events run in the same context as the main bashbot event loop
# so variables set here are persistent as long bashbot is running.
#
# Note: For the same reason event function MUST return imideatly!
# compute intensive tasks must be run in a nonblocking subshell,
# e.g. "(long running) &"
#  

# Availible events:
# on events startbot and init, this file is sourced
#
# BASHBOT_EVENT_INLINE	inline query received
# BASHBOT_EVENT_MESSAGE	any type of message received
# BASHBOT_EVENT_TEXT	message containing message text received
# BASHBOT_EVENT_CMD	a command is recieved
# BASHBOT_EVENT_REPLYTO	reply to message received
# BASHBOT_EVENT_FORWARD	forwarded message received
# BASHBOT_EVENT_CONTACT	contact received
# BASHBOT_EVENT_LOCATION	location or venue received
# BASHBOT_EVENT_FILE	file received
#
# BAHSBOT_EVENT_TIMER	this event is a bit special as it fires every Minute
#			and has 3 meanings: oneshot, everytime, every X minutes.
#
# all global variables and functions can be used in registered functions.
#
# parameters when loaded
# $1 event: init, startbot ...
# $2 debug: use "[[ "$2" = *"debug"* ]]" if you want to output extra diagnostic
#
# prameters on events
# $1 event: inline, message, ..., file
# $2 debug: use "[[ "$2" = *"debug"* ]]" if you want to output extra diagnostic
#

# export used events
export BASHBOT_EVENT_INLINE BASHBOT_EVENT_CMD BASHBOT_EVENT_REPLY BASHBOT_EVENT_TIMER

# any global variable defined by addons MUST be prefixed by addon name
EXAMPLE_ME="example"

# initialize after installation or update
if [[ "$1" = "init"* ]]; then 
	: # nothing to do
fi


# register on startbot
if [[ "$1" = "start"* ]]; then 
    # register to reply
    BASHBOT_EVENT_REPLY["${EXAMPLE_ME}"]="${EXAMPLE_ME}_reply"

    # any function defined by addons MUST be prefixed by addon name
    # function local variables can have any name, but must be LOCAL
    example_reply(){
	local msg="message"
	send_markdown_message "${CHAT[ID]}" "User *${USER[USERNAME]}* replied to ${msg} from *${REPLYTO[USERNAME]}*" &
    }

    # register to inline and command
    BASHBOT_EVENT_INLINE["${EXAMPLE_ME}"]="${EXAMPLE_ME}_multievent"
    BASHBOT_EVENT_CMD["${EXAMPLE_ME}"]="${EXAMPLE_ME}_multievent"

    # any function defined by addons MUST be prefixed by addon name
    # function local variables can have any name, but must be LOCAL
    example_multievent(){
	local type="$1"
	local msg="${MESSAGE[0]}"
	# shellcheck disable=SC2154
	[ "${type}" = "inline" ] && msg="${iQUERY[0]}"
	send_normal_message "${CHAT[ID]}" "${type} received: ${msg}" &
    }

    BASHBOT_EVENT_TIMER["${EXAMPLE_ME}after5min","-5"]="${EXAMPLE_ME}_after5min"

    # any function defined by addons MUST be prefixed by addon name
    # function local variables can have any name, but must be LOCAL
    example_after5min(){
	send_markdown_message "$(< "${BOTADMIN}")" "This is a one time event after 5 Minutes!" &
    }

    BASHBOT_EVENT_TIMER["${EXAMPLE_ME}every2min","2"]="${EXAMPLE_ME}_every2min"

    # any function defined by addons MUST be prefixed by addon name
    # function local variables can have any name, but must be LOCAL
    example_every2min(){
	send_markdown_message "$(< "${BOTADMIN}")" "This a a every 2 minute event ..." &
    }
fi