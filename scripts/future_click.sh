#!/bin/bash

die() {
	echo "$1"
	exit 1
}

position_correct=""

askCorrectPosition() {
	position_correct=""
	while [ "${position_correct}" = "" ]; do
		printf 'Do you want to click at coordinates: %s ? (y/n) ' "$1"
		read position_correct
		case "${position_correct}" in
			'y')
				echo "Confirmed.";;
			'n')
				echo "Declined. Retry now.";;
			*)
				echo "You need to accept or decline with y or n."
				position_correct="";;
		esac
	done
}

which xdotool || die "xdotool not installed"

last_position=""
position=""

count=0
count_needed=4
sleep_time='0.5'

time_goal=""

getTimeGoal() {
	confirmation=""
	while [ "${confirmation}" != "y" ]; do
		read -p "When do you want to click? (Input should be usable as input to date command) " time_goal
		if ! date "--date=${time_goal}" >/dev/null 2>&1; then
			echo "I wasn't able to parse this: ${time_goal}. Let's just retry..."
			continue
		fi
		printf "Are you sure you want to click at this time: %s ? (y/n) " "${time_goal}"
		read confirmation
		case "${confirmation}" in
			'y')
				echo "Confirmed.";;
			'n')
				echo "Declined. Retry now.";;
			*)
				echo "You need to accept or decline with y or n. Retry.";
		esac
	done
}

getTimeGoal
echo "Time goal is: ${time_goal}"

echo "Move your mouse to the position you wish to click and hold it still for $(echo "${count_needed}*${sleep_time}" | bc) seconds"

while true; do
	position="$(xdotool getmouselocation | cut -d ' ' -f 1,2)"

	if [ "${position}" = "${last_position}" ]; then
		((count++))
	else
		count=0
	fi

	if [ "${count}" -ge $count_needed ]; then
		askCorrectPosition "${position}"
		if [ "${position_correct}" = "y" ]; then
			break
		else
			count=0
		fi
	fi
	last_position="${position}"
	sleep "$sleep_time"
done

x="$(printf '%s' "$position" | cut -d ' ' -f 1 | cut -d ':' -f 2 -)"
y="$(printf '%s' "$position" | cut -d ' ' -f 2 | cut -d ':' -f 2 -)"
sleep $(($(date --date="${time_goal}" +%s) - $(date +%s)))
xdotool mousemove "${x}" "${y}"
xdotool mousedown 1
xdotool mouseup 1
