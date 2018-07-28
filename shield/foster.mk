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

$(call inherit-product, vendor/nvidia/shield/foster-generated.mk)
$(call inherit-product, vendor/nvidia/shield/foster-recovery.mk)
$(call inherit-product, vendor/nvidia/shield/app/shieldtech.mk)
$(call inherit-product, vendor/nvidia/shield/app/blakepairing.mk)
$(call inherit-product, vendor/nvidia/shield/app/consoleui.mk)
#$(call inherit-product, vendor/nvidia/shield/app/nvcamera.mk)
$(call inherit-product, vendor/nvidia/shield/ussrd/ussrd.mk)
$(call inherit-product, vendor/nvidia/shield/widevine/widevine.mk)

# Bootloader update
PRODUCT_PACKAGES += \
                    darcy.blob \
                    foster_e.blob \
                    foster_e_hdd.blob

# Firmware
PRODUCT_PACKAGES += \
                    model_frontal \
                    nvram_darcy_a00 \
                    nvram_foster_e_4354 \
                    nvram_foster_e_antenna_tuned_4354 \
                    nvram_loki_e_4354 \
                    nvram_loki_e_antenna_tuned_4354 \
                    fw_bcmdhd \
                    fw_bcmdhd-4354-N \
                    bcm4350 \
                    public.libraries \
                    adsp \
                    libnvaecfx \
                    nvaacdec \
                    nvadma \
                    nvapm \
                    nvmp3dec \
                    nvoice \
                    nvspkprot \
                    nvsrc \
                    nvavp_aacdec_ucode \
                    nvavp_aud_ucode \
                    nvavp_mp3dec_ucode \
                    nvavp_os_0ff00000 \
                    nvavp_os_8ff00000 \
                    nvavp_os_eff00000 \
                    nvavp_os_f7e00000 \
                    nvavp_vid_ucode \
                    nvavp_vid_ucode_alt \
                    tegra210b01_xusb_firmware \
                    tegra21x_xusb_firmware \
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
                    pmu_sig \
                    nvhost_nvdec020 \
                    nvhost_nvdec020_ns \
                    nvhost_nvdec020_prod \
                    nvhost_nvdec_bl020 \
                    nvhost_nvdec_bl020_prod \
                    nvhost_nvenc050 \
                    nvhost_nvjpg010 \
                    nvhost_tsec \
                    vic04_ucode

# Scripts / non-binary
PRODUCT_PACKAGES += run_ss_status.sh \
                    gps_select \
                    modemnic \
                    eks2.dat \
                    eks2_darcy.dat \
                    hdcp1x \
                    hdcp2x \
                    hdcp2xtest

# Raydium support
PRODUCT_PACKAGES += para_10_02_00_a0 \
                    para_10_03_00_20 \
                    para_10_03_00_b0 \
                    para_10_04_00_c0 \
                    para_10_06_00_b0 \
                    para_10_08_00_20 \
                    para_10_08_00_b0 \
                    para_10_09_01_c0 \
                    para_10_0a_00_b0 \
                    para_10_02_00_20 \
                    para_10_02_00_b0 \
                    para_10_03_00_a0 \
                    para_10_04_00_b0 \
                    para_10_05_00_c0 \
                    para_10_07_00_b0 \
                    para_10_08_00_a0 \
                    para_10_09_00_c0 \
                    para_10_09_02_c0 \
                    para_10_0b_00_a0

# Variant oemcrypto
PRODUCT_PACKAGES += liboemcrypto.loki \
                    liboemcrypto.darcy
