#!/system/bin/sh

# Copyright (c) 2012-2014, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

if [ $(getprop ro.boot.commchip_id) -gt 0 ]; then
	/system/bin/log -t "wifiloader" -p i "setting user configured value of WiFi chipset"
	setprop wifi.commchip_id $(getprop ro.boot.commchip_id)
	exit
fi
# vendor id defines
BRCM=0x02d0
TI=0x0097
MRVL=0x02df
brcm_symlink=y
automotive_device=n

# get wifi country code from factory partition
wifi_country_code=
if [ -f /mnt/factory/wifi/country.txt ]; then
	wifi_country_code=`cat /mnt/factory/wifi/country.txt`
fi
/system/bin/log -t "wifiloader" -p i "Factory partition wifi country code: $wifi_country_code"

#Sometime WiFi card enumeration gets delayed in kernel. Retry 3 times for WiFi card enumeration from kernel.
COUNT=0;
while [ $COUNT -le 3 ]; do
	#find hardware used and assigned corresponding mmc interface used for wifi chip
	sdmmc=$(getprop ro.wifi.sdmmc)
	if [ -z $sdmmc ]; then
		/system/bin/log -t "wifiloader" -p i "ro.wifi.sdmmc property not set, reading from sdmmc0"
		mmc=$(ls /sys/bus/platform/devices/sdhci-tegra.0/mmc_host)
	else
		/system/bin/log -t "wifiloader" -p i "ro.wifi.sdmmc property set, reading from sdmmc$sdmmc"
		mmc=$(ls /sys/bus/platform/devices/sdhci-tegra.$sdmmc/mmc_host)
	fi
	/system/bin/log -t "wifiloader" -p i "Using $mmc for WiFi"

	vendor=$(cat /sys/bus/sdio/devices/$mmc:0001:1/vendor)
	device=$(cat /sys/bus/sdio/devices/$mmc:0001:1/device)
	if [ -z $vendor ]; then
		/system/bin/log -t "wifiloader" -p e "WiFi card is not available! try $COUNT"
		sleep 2
		COUNT=$(($COUNT+1))
	else
		/system/bin/log -t "wifiloader" -p i "WiFi VendorID: $vendor, DeviceID: $device"
		break
	fi
done
if [ -z $vendor ]; then
	/system/bin/log -t "wifiloader" -p e "WiFi auto card detection fail"
fi

vendor_device="$vendor"_"$device"
vendor_device_country="$vendor"_"$device"_"$wifi_country_code"
#Read vendor and product idea enumerated during kernel boot
if [ -z "$(getprop persist.sys.commchip_vendor)" ]; then
	/system/bin/log -t "wifiloader" -p i "persist.sys.commchip_vendor not defined. Reading enumerated data"
	setprop persist.sys.commchip_vendor $vendor
	setprop persist.sys.commchip_device $device
	setprop persist.sys.commchip_country "$wifi_country_code"
elif [ $vendor_device_country = $(getprop persist.sys.commchip_vendor)"_"$(getprop persist.sys.commchip_device)"_"$(getprop persist.sys.commchip_country) ]; then
	/system/bin/log -t "wifiloader" -p i "persist.sys.commchip_vendor defined by user. Using user-defined config"
	#check if symlinks are available; if available, do not create symlinks
	#this check is needed when data partition is remounted after encryption
	if [ -L /data/misc/wifi/firmware/fw_bcmdhd.bin ]; then
		brcm_symlink=n
	fi
else
	/system/bin/log -t "wifiloader" -p i "Comm chip replaced by user. reset symlinks if needed"
	if [ $vendor = $BRCM ]; then
		/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd.bin
		/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd_apsta.bin
		/system/bin/rm /data/misc/wifi/firmware/nvram.txt
		if [ $device = "43341" ]; then
			/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd_a0.bin
			/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd_apsta_a0.bin
			/system/bin/rm /data/misc/wifi/firmware/nvram_43341_rev3.txt
			/system/bin/rm /data/misc/wifi/firmware/nvram_43341_rev4.txt
		fi

	fi
	setprop persist.sys.commchip_vendor $vendor
	setprop persist.sys.commchip_device $device
	setprop persist.sys.commchip_country "$wifi_country_code"
	/system/bin/rm /data/misc/wifi/wpa_supplicant.conf
	/system/bin/rm /data/misc/wifi/p2p_supplicant.conf
fi

if [ $(getprop ro.hardware) == "p1859" ]; then
	/system/bin/log -t "wifiloader" -p i "automotive device is detected"
	if [ -e /system/lib/modules/vcm/cfg80211.ko ]; then
		insmod /system/lib/modules/vcm/cfg80211.ko
	fi
	automotive_device=y
else
	/system/bin/log -t "wifiloader" -p i "mobile device is detected"
	if [ -e /system/lib/modules/cfg80211.ko ]; then
		insmod /system/lib/modules/cfg80211.ko
	fi
fi

#Find device and set configurations
#broadcomm comm chip
if [ $vendor = $BRCM ]; then
	if [ $device = "0x4329" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4329 chip identified"
		chip="4329"
	elif [ $device = "0x4330" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4330 chip identified"
		chip="4330"
	elif [ $device = "0x4334" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4334 chip identified"
		chip="4334"
	elif [ $device = "0xa94d" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM43341 chip identified"
		chip="43341"
	elif [ $device = "0x4324" ] && [ $automotive_device = y ]
	then
		/system/bin/log -t "wifiloader" -p i  "BCM43241-B4 chip identified"
		chip="43241-b4"
	elif [ $device = "0x4324" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM43241 chip identified"
		chip="43241"
	elif [ $device = "0x4335" ]; then
                /system/bin/log -t "wifiloader" -p i  "BCM4335 chip identified"
                chip="4335"
	elif [ $device = "0x4350" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4350 chip identified"
		chip="4350"
	elif [ $device = "0x4354" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4354 chip identified"
		chip="4354"
	fi

	if [ ! -f /data/misc/wifi/wpa_supplicant.conf ] && [ -f /system/etc/firmware/brcm_wpa.conf ]
	then
		/system/bin/log -t "wifiloader" -p i  "BRCM: WLAN0 copy /system/etc/firmware/brcm_wpa.conf"
		cp /system/etc/firmware/brcm_wpa.conf /data/misc/wifi/wpa_supplicant.conf
		if [ $(getprop ro.build.version.sdk) -gt 19 ]; then
			/system/bin/log -t "wifiloader" -p i  "BRCM: WLAN0 enable WOW triggers"
			echo "wowlan_triggers=any" >> /data/misc/wifi/wpa_supplicant.conf
		fi
		chmod 0660 /data/misc/wifi/wpa_supplicant.conf
		chown system:wifi /data/misc/wifi/wpa_supplicant.conf
	elif [ -f /data/misc/wifi/wpa_supplicant.conf ]; then
		wowlan_trigger_found=$(grep wowlan_triggers /data/misc/wifi/wpa_supplicant.conf)
		if [ -z $wowlan_trigger_found ]; then
			echo "wowlan_triggers=any" >> /data/misc/wifi/wpa_supplicant.conf
		fi
	fi

	if [ ! -f /data/misc/wifi/p2p_supplicant.conf ] && [ -f /system/etc/firmware/brcm_p2p.conf ]
	then
		/system/bin/log -t "wifiloader" -p i  "BRCM: p2p copy /system/etc/firmware/brcm_p2p.conf"
		cp /system/etc/firmware/brcm_p2p.conf /data/misc/wifi/p2p_supplicant.conf
		chmod 0660 /data/misc/wifi/p2p_supplicant.conf
		chown system:wifi /data/misc/wifi/p2p_supplicant.conf
	fi

	if [ $brcm_symlink = y ]; then
		/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd.bin /data/misc/wifi/firmware/fw_bcmdhd.bin
		/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd.bin /data/misc/wifi/firmware/fw_bcmdhd_apsta.bin
		if [ $chip = "43341" ]; then
			/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd_a0.bin /data/misc/wifi/firmware/fw_bcmdhd_a0.bin
			/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd_a0.bin /data/misc/wifi/firmware/fw_bcmdhd_apsta_a0.bin
			/system/bin/ln -s /system/etc/nvram_rev2.txt /data/misc/wifi/firmware/nvram.txt
			/system/bin/ln -s /system/etc/nvram_rev3.txt /data/misc/wifi/firmware/nvram_43341_rev3.txt
			/system/bin/ln -s /system/etc/nvram_rev4.txt /data/misc/wifi/firmware/nvram_43341_rev4.txt
		elif [ $wifi_country_code ]; then
			/system/bin/rm /data/misc/wifi/firmware/nvram_$chip.txt.*
			while read line
			do
				if [ ${line#ccode=} != $line ]; then
					echo "ccode=$wifi_country_code" >> /data/misc/wifi/firmware/nvram_$chip.txt.$wifi_country_code
				else
					echo $line >> /data/misc/wifi/firmware/nvram_$chip.txt.$wifi_country_code
				fi
			done < /system/etc/nvram_$chip.txt
			/system/bin/chmod 644 /data/misc/wifi/firmware/nvram_$chip.txt.$wifi_country_code
			/system/bin/ln -s /data/misc/wifi/firmware/nvram_$chip.txt.$wifi_country_code /data/misc/wifi/firmware/nvram.txt
		else
		/system/bin/ln -s /system/etc/nvram_$chip.txt /data/misc/wifi/firmware/nvram.txt
		fi
	fi
	if [ $automotive_device = y ]; then
		/system/bin/log -t "wifiloader" -p i "load bcmdhd module for automotive device"
		if [ -e /system/lib/modules/vcm/bcmdhd.ko ]; then
			insmod /system/lib/modules/vcm/bcmdhd.ko
			/system/bin/ln -s /sys/module/bcmdhd/parameters/firmware_path /data/misc/wifi/firmware/firmware_path
		else
			/system/bin/log -t "wifiloader" -p i "KO not found, compiled part of kernel"
			/system/bin/ln -s /sys/module/bcmdhd/parameters/firmware_path /data/misc/wifi/firmware/firmware_path
		fi
	else
		/system/bin/log -t "wifiloader" -p i "load bcmdhd module for mobile device"
		if [ -e /system/lib/modules/bcmdhd.ko ]; then
			insmod /system/lib/modules/bcmdhd.ko
			/system/bin/ln -s /sys/module/bcmdhd/parameters/firmware_path /data/misc/wifi/firmware/firmware_path
		else
			/system/bin/log -t "wifiloader" -p i "KO not found, compiled part of kernel"
			/system/bin/ln -s /sys/module/bcmdhd/parameters/firmware_path /data/misc/wifi/firmware/firmware_path
		fi
	fi
#marvel comms chip
elif [ $vendor_device = "$MRVL""_0x9129" ]; then
	/system/bin/log -t "wifiloader" -p i  "MRVL8797 chip identified"
	if [ ! -f /data/misc/wifi/wpa_supplicant.conf ]; then
		cp /system/etc/firmware/marvel_wpa.conf /data/misc/wifi/wpa_supplicant.conf
		chmod 0660 /data/misc/wifi/wpa_supplicant.conf
		chown system:wifi /data/misc/wifi/wpa_supplicant.conf
	fi
	if [ ! -f /data/misc/wifi/p2p_supplicant.conf ]; then
		cp /system/etc/firmware/marvel_p2p.conf /data/misc/wifi/p2p_supplicant.conf
		chmod 0660 /data/misc/wifi/p2p_supplicant.conf
		chown system:wifi /data/misc/wifi/p2p_supplicant.conf
	fi
	if [ -e /system/lib/modules/sd8797mlan.ko ]; then
		insmod /system/lib/modules/sd8797mlan.ko
		insmod /system/lib/modules/sd8797.ko drv_mode=5 cfg80211_wext=12 fw_name=sd8797_uapsta.bin max_vir_bss=1 sta_name=wlan wfd_name=p2p
		insmod /system/lib/modules/mbt8797.ko fw_name=sd8797_uapsta.bin
		chown bluetooth net_bt_stack /dev/mbtchar0
	else
		/system/bin/log -t "wifiloader" -p i "KO not found, compiled part of kernel"
	fi
elif [ $vendor_device = "$MRVL""_0x912d" ]; then
	/system/bin/log -t "wifiloader" -p i  "MRVL8897 chip identified"
	if [ ! -f /data/misc/wifi/wpa_supplicant.conf ]; then
		cp /system/etc/firmware/marvel_wpa.conf /data/misc/wifi/wpa_supplicant.conf
		chmod 0660 /data/misc/wifi/wpa_supplicant.conf
		chown system:wifi /data/misc/wifi/wpa_supplicant.conf
	fi
	if [ ! -f /data/misc/wifi/p2p_supplicant.conf ]; then
		cp /system/etc/firmware/marvel_p2p.conf /data/misc/wifi/p2p_supplicant.conf
		chmod 0660 /data/misc/wifi/p2p_supplicant.conf
		chown system:wifi /data/misc/wifi/p2p_supplicant.conf
	fi
	if [ -e /system/lib/modules/sd8897mlan.ko ]; then
		insmod /system/lib/modules/sd8897mlan.ko
		insmod /system/lib/modules/sd8897.ko drv_mode=5 cfg80211_wext=12 fw_name=sd8897_uapsta.bin max_vir_bss=1 sta_name=wlan wfd_name=p2p p2p_enh=1
		insmod /system/lib/modules/mbt8897.ko fw_name=sd8897_uapsta.bin
		chown bluetooth net_bt_stack /dev/mbtchar0
	else
		/system/bin/log -t "wifiloader" -p i "KO not found, compiled part of kernel"
	fi
fi

#increase the wmem default and wmem max size
echo 262144 > /proc/sys/net/core/wmem_default
echo 262144 > /proc/sys/net/core/wmem_max
