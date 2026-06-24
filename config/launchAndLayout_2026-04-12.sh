#!/bin/sh

# Launch apps sequentially, waiting for each to register before starting the next
MemaMo --noconfigui --noupdates &
sleep 1
Umsci --noupdates --noconfigui &
sleep 1
MemaRe --noconfigui --noupdates &
sleep 2

swaymsg '[class="Mema.Mo"] resize set width 25ppt'
swaymsg '[class="Umsci"] resize set width 55ppt'
swaymsg '[class="Mema.Re"] resize set width 20ppt'
