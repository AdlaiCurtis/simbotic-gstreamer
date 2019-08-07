#!/usr/bin/env bash

docker run --rm --runtime=nvidia -ti \
    -e DISPLAY=$DISPLAY \
    -e PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    -e PULSE_COOKIE=/tmp/pulseaudio.cookie \
    -v /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --network=host \
    --cap-add=SYS_PTRACE \
    sim-gst
