#!/bin/sh

# Print out time with precision to 5 second intervals

while true; do
    CURRENT_TIME=$(date +"%s.%3N")
    SECONDS=$(echo "$CURRENT_TIME" | cut -d "." -f1)
    MILLIS=$(echo "$CURRENT_TIME" | cut -d "." -f2)

    SLEEP_TIME="$((4 - (SECONDS % 5))).$((1000 - 10#$MILLIS))"

    date +%H:%M:%S
    sleep "$SLEEP_TIME"
done
