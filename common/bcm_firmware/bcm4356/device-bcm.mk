BCM_FW_SRC_FILE_STA := fw_4356a3_prod.bin

PRODUCT_COPY_FILES += \
    vendor/nvidia/common/bcm_firmware/bcm4356/$(BCM_FW_SRC_FILE_STA):$(TARGET_COPY_OUT_VENDOR)/firmware/fw_bcmdhd.bin
