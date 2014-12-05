#!/bin/sh
#
# This is a simple shell wrapper that allows applications to be run on the
# Altura.  It sets required environment variables and performs minor
# argument fix-ups.
#
# $Log: run.sh,v $
# Revision 1.1  2004/07/15 00:04:22  papke
# Initial version
#
#

# Customizable defaults
DIR=/var/gtech/webshow
DFLT_PROGRAM=$DIR/wsbrowser
DFLT_DISPLAY=:1.0
DFLT_PAGE=

PROGRAM=""

#
# Program name given in $1
#
if [ $# -gt 1 ]
then
	PROGRAM=$1
	shift
fi

#
# Program not given, try to guess a default
#
if [ -z "$PROGRAM" ]
then
	PROGRAM=$DFLT_PROGRAM
fi

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
if [ -n "$FONTCONFIG_PATH" ]; then
	echo "FONTCONFIG_PATH=$FONTCONFIG_PATH"
fi
echo " "

#
# Start it
#
export MOZILLA_FIVE_HOME LD_LIBRARY_PATH DISPLAY
exec $PROGRAM $PAGE

