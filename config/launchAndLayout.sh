#!/bin/sh

# Launch apps sequentially, waiting for each to register before starting the next
MemaMo --noconfigui --noupdates &
sleep 1
Umsci --noupdates &
sleep 1
MemaRe --noconfigui --noupdates &
sleep 2

swaymsg '[class="Mema.Mo"] resize set width 30ppt'
swaymsg '[class="Umsci"] resize set width 45ppt'
swaymsg '[class="Mema.Re"] resize set width 25ppt'
