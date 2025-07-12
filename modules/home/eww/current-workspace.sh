#!/bin/sh

active_workspace() {
    hyprctl activeworkspace -j | jq -c -r -M
}

handle() {
    case $1 in
        'focusedmonv2'*) active_workspace ;;
        'workspacev2'*) active_workspace ;;
    esac
}

active_workspace
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
