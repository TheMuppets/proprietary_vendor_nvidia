#!/system/bin/sh
# Copyright (c) 2012-2014, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

BRCM=0x02d0
TI=0x0097
MRVL=0x02df
vendor=$(getprop persist.commchip_vendor)
if [ $vendor == $BRCM ]; then
	/system/bin/log -t "wpa_supplicant.sh" -p i "Executing wpa_supplicant for BRCM chips"
	/system/bin/logwrapper /system/bin/wpa_supplicant -iwlan0 -Dnl80211 -c/data/misc/wifi/wpa_supplicant.conf -z /data/misc/wifi/p2p_supplicant.conf -O/data/misc/wifi/sockets -e/data/misc/wifi/entropy.bin -puse_p2p_group_interface=1p2p_device=1 -g@android:wpa_wlan0
elif [ $vendor == $MRVL ]; then
	/system/bin/log -t "wpa_supplicant.sh" -p i "Executing wpa_supplicant for Marvell chips"
	/system/bin/logwrapper /system/bin/wpa_supplicant -iwlan0 -Dnl80211 -c/data/misc/wifi/wpa_supplicant.conf  -O/data/misc/wifi/sockets -N -ip2p0 -Dnl80211 -c /data/misc/wifi/p2p_supplicant.conf -e/data/misc/wifi/entropy.bin -puse_p2p_group_interface=1 -g@android:wpa_wlan0
else
	/system/bin/log -t "wpa_supplicant.sh" -p i "No known chip found skipping wpa_supplicant execution"
fi
