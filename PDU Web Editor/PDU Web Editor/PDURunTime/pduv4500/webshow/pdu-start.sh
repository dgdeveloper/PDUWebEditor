#!/bin/sh

# Customizable defaults
DFLT_DISPLAY=:1
DIR=/var/gtech/webshow
PROGRAM=$DIR/wsbrowser
DFLT_PAGE=pdu/Main.swf

# Run out of PDU project directory
cd $DIR

#
# Create a symbolic link from /dev/fb1 to the real device interface.
# This makes consistent with the main display.
#
if  [ ! -f /dev/fb1 ]
then
	ln -s /dev/fb/1 /dev/fb1
fi

#
# The FRAMEBUFFER environment variable specifies the device used
# by the Xfbdev2 X-Server.
#
FRAMEBUFFER=/dev/fb1 ; export FRAMEBUFFER

echo "Starting X server on " $DFLT_DISPLAY " using " $FRAMEBUFFER
./Xfbdev2 $DFLT_DISPLAY &

# Delay to give the X-Server a chance to start
sleep 15

#
# Page name given in $1
#
if [ $# -gt 0 ]
then
	PAGE=$1
fi

if [ -z "$PAGE" ]
then
	PAGE=$DFLT_PAGE
fi

if [ `expr substr $PAGE 1 1` != / ]
then
        PAGE=`pwd`/$PAGE
fi

PAGE=file://$PAGE

#
# Set DISPLAY
#
DISPLAY=$DFLT_DISPLAY


#
# Set MOZILLA_FIVE_HOME
#
MOZILLA_FIVE_HOME=$DIR

#
# Set LD_LIBRARY_PATH
#
LD_LIBRARY_PATH=${DIR}:${DIR}/components:${DIR}/plugins:${LD_LIBRARY_PATH}

#
# Give a little feedback
#
echo "MOZILLA_FIVE_HOME=$MOZILLA_FIVE_HOME"
echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "          DISPLAY=$DISPLAY"
echo "          PROGRAM=$PROGRAM"
echo "             PAGE=$PAGE"
echo " "

#
# Start it
#
export MOZILLA_FIVE_HOME LD_LIBRARY_PATH DISPLAY
exec $PROGRAM $PAGE

exit 0

