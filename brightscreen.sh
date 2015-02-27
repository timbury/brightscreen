#!/bin/sh

# Check and control LCD screen brightness values from the command line.
# To change brightness, must be run with root privileges, try sudo.

# Get max value - do not exceed this. 
# Default = 5273
max=`cat /sys/class/backlight/intel_backlight/max_brightness`

# Set min arbitrarily
min=1024
# Black level found in /sys/class/backlight/intel_backlight/bl_power
# (should be 0)

# Get current level
# Default = 1054
current=`cat /sys/class/backlight/intel_backlight/brightness`

# Deal with no arguments
if [ "$#" = "0" ]; then
    echo "Usage: `basename $0`  OPTIONS [-m|-c|-r|-l|-h]";
    exit 1
fi

# Get arguments
while getopts "mcrlh" opt; do
  case $opt in
    m)
      echo "Max brightness allowed is" $max
    ;;
    c)
      echo "Current brightness level is" $current
    ;;
    r)
      echo -n "Raise brightness by > "
      read raise
      total=`expr $current + $raise`
      if [ $total -le $max ]
      then
        echo "Raising brightness to" $total
        `echo $total > /sys/class/backlight/intel_backlight/brightness`
      else
        echo "Too bright!"
      fi
    ;;
    l)
      echo -n "Lower brightness by > "
      read lower
      total=`expr $current - $lower`
      if [ $total -ge $min ]
      then
        echo "Lowering brightness to" $total
        `echo $total > /sys/class/backlight/intel_backlight/brightness`
      else
        echo "Too dim!"
      fi
    ;;
    h)
      echo "Usage: `basename $0` OPTIONS [-m|-c|-r|-l|-h]"
      echo "Check or adjust screen brightness levels."
      echo ""
      echo "  -m      check maximum brightness allowed"
      echo "  -c      check current brightness level"
      echo "  -r      raise screen brightness level"
      echo "  -l      lower screen brightness level"
      echo "  -h      display this help and exit"
      echo ""
    ;;
  esac
done

exit 0

