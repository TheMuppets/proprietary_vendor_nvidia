# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS_BLAKE),TRUE)

# Apk
PRODUCT_PACKAGES += \
    BlakePairing \
    NvRpxService

# Bins
PRODUCT_PACKAGES += \
    blake \
    lota

# Libs
PRODUCT_PACKAGES += \
    libnvwifi-service \
    vendor.nvidia.hardware.shieldtech.inputflinger@1.0-service \
    vendor.nvidia.hardware.shieldtech.inputflinger@1.0-service.rc \
    vendor.nvidia.hardware.shieldtech.inputflinger@1.0 \
    vendor.nvidia.hardware.shieldtech.input@1.0

ifeq ($(TARGET_ARCH),arm64)
PRODUCT_PACKAGES += \
    vendor.nvidia.hardware.shieldtech.inputflinger@1.0_32
endif

# Controller firmware updates
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield/shieldtech/firmware/Blake.blkz:$(TARGET_COPY_OUT_VENDOR)/oem/firmware/Blake.blkz \
    vendor/nvidia/shield/shieldtech/firmware/Jarvis.blkz:$(TARGET_COPY_OUT_VENDOR)/oem/firmware/Jarvis.blkz \
    vendor/nvidia/shield/shieldtech/firmware/Pepper.blkz:$(TARGET_COPY_OUT_VENDOR)/oem/firmware/Pepper.blkz \
    vendor/nvidia/shield/shieldtech/firmware/Thunderstrike.blkz:$(TARGET_COPY_OUT_VENDOR)/oem/firmware/Thunderstrike.blkz \
    vendor/nvidia/shield/shieldtech/firmware/Thunderstrike_locale.blkz:$(TARGET_COPY_OUT_VENDOR)/oem/firmware/Thunderstrike_locale.blkz

# Media files
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield/shieldtech/media/sync_test.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/sync_test.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_finish_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_finish_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_finish_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_finish_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_loop_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_loop_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_loop_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_loop_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_start_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_start_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_start_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/ota/ota_start_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_connecting_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_connecting_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_connecting_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_connecting_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_error_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_error_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_error_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_error_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_success_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_success_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_success_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/pair_success_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/BJ/EU/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/BJ/EU/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/BJ/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/BJ/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/BJ/first_pair_start.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/BJ/first_pair_start.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/TP/AP/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/TP/AP/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/TP/CN/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/TP/CN/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/TP/EU/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/TP/EU/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/TP/first_pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/TP/first_pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/first_pair/TP/first_pair_start.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/first_pair/TP/first_pair_start.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_found_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_found_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_found_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_found_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_found_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_found_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_found_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_found_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/BJ/pair_start.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/BJ/pair_start.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_found_BLAKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_found_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_found_JARVIS.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_found_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_found_PEPPER.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_found_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_found_THUNDERSTRIKE.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_found_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_loop.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/TP/pair_start.mp4:$(TARGET_COPY_OUT_VENDOR)/oem/media/blakepairing/pairing/TP/pair_start.mp4

endif
