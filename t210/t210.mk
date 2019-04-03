# Copyright (C) 2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := vendor/nvidia/t210

$(call inherit-product, $(LOCAL_PATH)/t210-recovery.mk)

# Audio firmware
PRODUCT_PACKAGES += \
    adsp \
    nvaacdec \
    nvadma \
    nvadma_tx \
    nvapm \
    nvmp3dec \
    nvoice \
    nvspkprot \
    nvsrc

# Xusb firmware
PRODUCT_PACKAGES += \
    tegra210b01_xusb_firmware \
    tegra21x_xusb_firmware

# GPU firmware
PRODUCT_PACKAGES += \
    acr_ucode \
    fecs \
    fecs_sig \
    gpccs \
    gpmu_ucode \
    gpmu_ucode_desc \
    gpmu_ucode_image \
    gpu2cde \
    NETB_img \
    pmu_bl \
    pmu_sig

# General firmware
PRODUCT_PACKAGES += \
    nvhost_nvdec020 \
    nvhost_nvdec020_ns \
    nvhost_nvdec020_prod \
    nvhost_nvdec_bl020 \
    nvhost_nvdec_bl020_prod \
    nvhost_nvdec_bl_no_wpr020 \
    nvhost_nvenc050 \
    nvhost_nvjpg010 \
    nvhost_tsec \
    vic04_ucode

# Oemcrypto
ifeq ($(TARGET_TEGRA_WIDEVINE),true)
PRODUCT_PACKAGES += liboemcrypto
endif
