#!/bin/sh

monitors=$(bspc query --monitors --names)

for monitor in ${monitors}; do
	for i in $(seq 1 9); do
		bspc desktop "${monitor}_${i}" --to-monitor "${monitor}"
	done
done

while bspc desktop Desktop --remove; do :; done >/dev/null 2>&1
