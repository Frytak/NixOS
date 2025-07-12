#!/bin/sh

IFNAME=$(ip route show default | awk '/default/ {print $5}')

# No default route
if [ -z "$IFNAME" ]; then
    echo ""
    return
fi

PRETTY_NAME=$(nmcli -t -f GENERAL.CONNECTION device show "$IFNAME" | cut -d ':' -f2)
if [ -d "/sys/class/net/$IFNAME/phy80211" ]; then
    FREQ=$(nmcli -t -f IN-USE,FREQ device wifi list ifname wlo1 | grep "^\*" | cut -d ':' -f2 | cut -d ' ' -f1)
    G_FREQ=$(echo "scale=1; $FREQ / 1000" | bc -l)

    echo "$PRETTY_NAME (${G_FREQ}GHz)"
else
    echo "$PRETTY_NAME (Ethernet)"
fi
