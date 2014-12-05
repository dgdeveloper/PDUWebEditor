#!/bin/sh
#
# $Log:$
#
#

# Customizable defaults
DFLT_DISPLAY=:1

if  [ ! -f /dev/fb1 ]
then
	ln -s /dev/fb/1 /dev/fb1
fi

echo "Starting X server on " $DFLT_DISPLAY
./Xfbdev2 $DFLT_DISPLAY &


