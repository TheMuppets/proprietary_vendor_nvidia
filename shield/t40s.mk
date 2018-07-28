# Copyright (C) 2017 The Android Open Source Project
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

$(call inherit-product, vendor/nvidia/shield/t40s-generated.mk)
$(call inherit-product, vendor/nvidia/shield/t40s-recovery.mk)
$(call inherit-product, vendor/nvidia/shield/app/shieldtech.mk)
$(call inherit-product, vendor/nvidia/shield/app/blakepairing.mk)
$(call inherit-product, vendor/nvidia/shield/app/consoleui.mk)
$(call inherit-product, vendor/nvidia/shield/widevine/widevine.mk)

PRODUCT_PACKAGES += gps_select \
                    modemnic \
                    hdcp1x \
                    hdcp2x \
                    hdcp2xtest

# Firmware
PRODUCT_PACKAGES += \
                    nvram_43241 \
                    bcm43241 \
                    fw_bcmdhd \
                    nvavp_aud_ucode \
                    nvavp_os_0ff00000 \
                    nvavp_os_eff00000 \
                    nvavp_vid_ucode_alt \
                    nvhost_msenc02 \
                    nvhost_tsec

# Oemcrypto
PRODUCT_PACKAGES += libstlport
