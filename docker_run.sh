#!/usr/bin/env bash

docker run --rm --runtime=nvidia -ti \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --network=host \
    --cap-add=SYS_PTRACE \
    sim-gst
