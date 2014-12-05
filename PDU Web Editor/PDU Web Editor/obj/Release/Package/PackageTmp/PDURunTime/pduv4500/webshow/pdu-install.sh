#!/bin/sh

LOCK_FILE=/tmp/install-lock
if [ -f $LOCK_FILE ]
then
	exit 1
fi
echo > $LOCK_FILE

USB_DIR=/mnt/usb
USB_INSTALL_SCRIPT=install.sh

#
# Load USB kernel modules if required
#
USB_LOADED_FLAG=/tmp/usb-loaded

if [ ! -f $USB_LOADED_FLAG ]
then
	insmod usbcore
	insmod scsi_mod
	insmod usb-uhci
	insmod usb-storage
	insmod sd_mod
	echo > $USB_LOADED_FLAG
	
	# give modules a chance to initialize
	sleep 5
fi

#
# Access the USB drive
#
if [ ! -d $USB_DIR ]
then
	mkdir $USB_DIR
fi

if [ ! -f $USB_DIR/$USB_INSTALL_SCRIPT ]
then
	# No installation script.  Assume no mounted usb drive
	mount /dev/scsi/host0/bus0/target0/lun0/part1 $USB_DIR
fi

#
# Run the installation script on the USB drive
#
if [ -x $USB_DIR/$USB_INSTALL_SCRIPT ]
then
	echo "Running installation script"
	(cd $USB_DIR && ./$USB_INSTALL_SCRIPT)
	echo "Finished installation script"
fi

#
# Unmount the USB_DRIVE prior to exit
#
cd /
sleep 5
umount $USB_DIR

rm $LOCK_FILE

exit 0

