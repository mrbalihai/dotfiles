#!/bin/bash

LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | tr -s ' ' | cut -d ' ' -f2)

if [ $LID_STATE == "closed" ]
then
    xrandr --output LVDS-1 --off
fi
