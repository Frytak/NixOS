#!/bin/bash

swww init &
BACK_PID=$!
wait $BACK_PID
swww img /path/to/img
