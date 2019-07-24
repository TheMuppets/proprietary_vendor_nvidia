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

LOCAL_PATH := vendor/nvidia/t194

$(call inherit-product, $(LOCAL_PATH)/t194-recovery.mk)

# Xusb firmware
PRODUCT_PACKAGES += \
    tegra19x_xusb_firmware

# GPU firmware
PRODUCT_PACKAGES += \
    acr_ucode \
    fecs \
    fecs_sig \
    gpccs \
    gpccs_sig \
    gpmu_ucode \
    gpmu_ucode_desc \
    gpmu_ucode_image \
    NETA_img \
    NETB_img \
    NETC_img \
    NETD_img \
    pmu_bl \
    pmu_sig

# General firmware
PRODUCT_PACKAGES += \
    nvhost_nvdec040_ns \
    nvhost_nvdla010 \
    nvhost_nvenc070 \
    nvhost_nvjpg012 \
    nvhost_pva010 \
    nvhost_vic042
