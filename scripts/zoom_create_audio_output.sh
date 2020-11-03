#!/bin/sh

pactl load-module module-null-sink sink_name=output_for_zoom sink_properties=device.description=output_for_zoom
pactl load-module module-null-sink sink_name=output_of_zoom_distributable sink_properties=device.description=output_of_zoom_disitributable
pactl load-module module-loopback latency_msec=30 adjust_time=3 source=output_for_zoom.monitor sink=output_of_zoom_distributable
pactl load-module module-loopback latency_msec=30 adjust_time=3 source=output_for_zoom.monitor
