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

LOCAL_PATH := vendor/nvidia/t124

$(call inherit-product, $(LOCAL_PATH)/t124-recovery.mk)

# AVP firmware
PRODUCT_PACKAGES += \
    nvavp_aacdec_ucode \
    nvavp_aud_ucode \
    nvavp_mp3dec_ucode \
    nvavp_os_0ff00000 \
    nvavp_os_8ff00000 \
    nvavp_os_eff00000 \
    nvavp_os_f7e00000 \
    nvavp_vid_ucode_alt

# Xusb firmware
PRODUCT_PACKAGES += \
    tegra12x_xusb_firmware

# GPU firmware
PRODUCT_PACKAGES += \
    fecs \
    gpccs \
    gpmu_ucode \
    NETB_img

# General firmware
PRODUCT_PACKAGES += \
    nvhost_msenc031 \
    nvhost_tsec \
    vic03_ucode

# Oemcrypto
ifeq ($(TARGET_TEGRA_WIDEVINE),true)
PRODUCT_PACKAGES += liboemcrypto
endif
