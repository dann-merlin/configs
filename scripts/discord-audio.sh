#!/bin/bash

# see https://wiki.archlinux.org/index.php/PulseAudio/Examples#Mixing_additional_audio_into_the_microphone's_audio

is_num() {
	case "$1" in
		("" | *[![:digit:]]*)
			echo "Please input a number!"
			return 1;
	esac
	return 0
}

if [ "$1" = "cleanup" ]; then
	while [ "$#" -gt 1 ]; do
		if ! is_num "$2"; then
			echo -n "Please only input numbers! Haven't cleaned up all given modules. "
			echo "Run this again with corrected arguments: \"$@\"";
			exit 1
		fi
		pactl unload-module "$2"
		echo "Unloaded module \"$2\""
		shift
	done
	echo "Unloaded all modules!"
	exit 0
fi

remembered_modules=""

remember_module() {
	module="$( $@ )"
	remembered_modules="${module} ${remembered_modules}"
}

while [ "${microphone}" = "" ]; do
	sources_list="$(pacmd list-sources | sed -ne 's/\s*name:\s*<\(.*\)>/\1/p')"
	echo "Which of these is your microphone? "
	printf '%s' "${sources_list}" | awk '{ print NR " " $0 }'
	read -p "Select by entering the index (ex. 3): " sources_list_index
	if ! is_num "${sources_list_index}"; then
		echo "That's not a number. Try again."
		continue
	fi
	microphone="$(printf '%s' "${sources_list}" | awk "{ if (NR == ${sources_list_index}) "'{ print $0 }}')"
	getConfirmation=""
	while [ "${getConfirmation}" = "" ]; do
		read -p "Selected Microphone \"$microphone\", correct? [y/n] " ok
		case "${ok}" in
			'y')
				echo "Confirmed selection \"${microphone}\"."
				getConfirmation=done;;
			'n')
				echo "Declined selection."
				microphone=""
				getConfirmation=done;;
			*)
				echo "You need to accept or decline with y or n."
				getConfirmation="" ;;
		esac
	done
done

speakers=""

while [ "${speakers}" = "" ]; do
	sinks_list="$(pacmd list-sinks | sed -ne 's/\s*name:\s*<\(.*\)>/\1/p')"
	echo "Which of these are your speakers? "
	printf '%s' "${sinks_list}" | awk '{ print NR " " $0 }'
	read -p "Select by entering the index (ex. 3): " sinks_list_index
	if ! is_num "${sinks_list_index}"; then
		echo "That's not a number. Try again."
		continue
	fi
	speakers="$(printf '%s' "${sinks_list}" | awk "{ if (NR == ${sinks_list_index}) "'{ print $0 }}')"
	getConfirmation=""
	while [ "${getConfirmation}" = "" ]; do
		read -p "Selected Speakers \"$speakers\", correct? [y/n] " ok
		case "${ok}" in
			'y')
				echo "Confirmed selection \"${speakers}\"."
				getConfirmation=done;;
			'n')
				echo "Declined selection."
				speakers=""
				getConfirmation=done;;
			*)
				echo "You need to accept or decline with y or n."
				getConfirmation="" ;;
		esac
	done
done

echo "Setting up echo cancellation"
pactl load-module module-echo-cancel use_master_format=1 aec_method=webrtc \
      aec_args="analog_gain_control=0\\ digital_gain_control=1\\ experimental_agc=1\\ noise_suppression=1\\ voice_detection=1\\ extended_filter=1" \
      source_master="$microphone" source_name=mic_input_for_echo_cancel source_properties=device.description=mic_input_for_echo_cancel \
        sink_master="$speakers"     sink_name=speakers_out_echo_cancel   sink_properties=device.description=speakers_out_echo_cancel

echo "Creating virtual output devices"
remember_module pactl load-module module-null-sink sink_name=record_program_sink     sink_properties=device.description=record_program_sink
remember_module pactl load-module module-null-sink sink_name=system_audio_with_mic sink_properties=device.description=system_audio_with_mic

echo "Creating loopbacks"
remember_module pactl load-module module-loopback latency_msec=30 adjust_time=3 source=mic_input_for_echo_cancel           sink=system_audio_with_mic
remember_module pactl load-module module-loopback latency_msec=30 adjust_time=3 source=record_program_sink.monitor sink=system_audio_with_mic
remember_module pactl load-module module-loopback latency_msec=30 adjust_time=3 source=record_program_sink.monitor sink=speakers_out_echo_cancel

echo "Setting default devices"
remember_module pactl set-default-source system_audio_with_mic.monitor
remember_module pactl set-default-sink   record_program_sink.monitor

echo "To clean up this mess, remove the following modules:"

printf "%s\n" "${remembered_modules}"

echo "You can easily do this, by calling this script again, by calling it like this:"
echo "$0 cleanup ${remembered_modules}"
