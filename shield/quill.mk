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

$(call inherit-product, vendor/nvidia/shield/quill-generated.mk)
$(call inherit-product, vendor/nvidia/shield/app/shieldtech.mk)
$(call inherit-product, vendor/nvidia/shield/app/blakepairing.mk)
$(call inherit-product, vendor/nvidia/shield/ussrd/ussrd.mk)
$(call inherit-product, vendor/nvidia/shield/widevine/widevine.mk)

# Firmware
PRODUCT_PACKAGES += \
                    nvram_foster_e_4354 \
                    nvram_foster_e_antenna_tuned_4354 \
                    fw_bcmdhd \
                    bcm4350 \
                    public.libraries \
                    tegra18x_xusb_firmware \
                    acr_ucode \
                    fecs \
                    fecs_sig \
                    gpccs \
                    gpccs_sig \
                    gpmu_ucode \
                    gpmu_ucode_desc \
                    gpmu_ucode_image \
                    gpu2cde \
                    NETA_img \
                    pmu_bl \
                    pmu_sig \
                    nvhost_nvdec030 \
                    nvhost_nvdec030_ns \
                    nvhost_nvdec030_prod \
                    nvhost_nvdec_bl030_prod \
                    nvhost_nvenc061 \
                    nvhost_nvjpg011 \
                    vic04_ucode

# Scripts / non-binary
PRODUCT_PACKAGES += run_ss_status.sh \
                    eks2.dat \
                    hdcp1x \
                    hdcp2x \
                    hdcp2xtest
