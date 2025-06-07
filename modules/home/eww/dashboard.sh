#!/bin/sh

source $HOME/.config/eww/variables.sh

SCREEN=$("$FOCUSED_SCREEN")

function open() {
    echo "$SCREEN" > "$DASHBOARD_OPEN"
    eww open --screen "$SCREEN" overlay
    eww open --screen "$SCREEN" music
    eww open --screen "$SCREEN" shutdown
    eww open --screen "$SCREEN" reboot

    if [ -e "$SHUTDOWN_CONFIRMATION_OPEN" ]; then
        eww open --screen "$SCREEN" shutdown-confirmation
    fi

    if [ -e "$REBOOT_CONFIRMATION_OPEN" ]; then
        eww open --screen "$SCREEN" reboot-confirmation
    fi
}

function close() {
    if [ -e "$SHUTDOWN_CONFIRMATION_OPEN" ]; then
        eww close shutdown-confirmation
    fi

    if [ -e "$REBOOT_CONFIRMATION_OPEN" ]; then
        eww close reboot-confirmation
    fi

    eww close overlay music shutdown reboot
    rm "$DASHBOARD_OPEN"
}

if [ -e "$DASHBOARD_OPEN" ] && ! grep -q "$SCREEN" "$DASHBOARD_OPEN"; then
    close
    open
elif [ ! -e "$DASHBOARD_OPEN" ]; then
    open
else
    close
fi
