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

$(call inherit-product, vendor/nvidia/common/bcm_firmware/bcm4354/device-bcm.mk)
$(call inherit-product, $(LOCAL_PATH)/clm.mk)
$(call inherit-product, $(LOCAL_PATH)/nvram.mk)

PRODUCT_PACKAGES += \
                    bcm4350 \
                    BCM4354A2-13d3-3488 \
                    bcm4356 \
                    fw_bcmdhd_4356 \
                    brcmfmac4356-pcie
