BCM_FW_SRC_FILE_STA := sdio-ag-pno-p2p-proptxstatus-dmatxrc-rxov-pktfilter-keepalive-aoe-vsdb-wapi-wl11d-sr-srvsdb-opt1.bin

PRODUCT_COPY_FILES += \
    vendor/nvidia/common/bcm_firmware/bcm43241/$(BCM_FW_SRC_FILE_STA):$(TARGET_COPY_OUT_VENDOR)/firmware/fw_bcmdhd.bin
