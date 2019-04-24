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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_aacdec_ucode
LOCAL_SRC_FILES            := nvavp_aacdec_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_aud_ucode
LOCAL_SRC_FILES            := nvavp_aud_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_mp3dec_ucode
LOCAL_SRC_FILES            := nvavp_mp3dec_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_os_0ff00000
LOCAL_SRC_FILES            := nvavp_os_0ff00000.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_os_8ff00000
LOCAL_SRC_FILES            := nvavp_os_8ff00000.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_os_eff00000
LOCAL_SRC_FILES            := nvavp_os_eff00000.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_os_f7e00000
LOCAL_SRC_FILES            := nvavp_os_f7e00000.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvavp_vid_ucode_alt
LOCAL_SRC_FILES            := nvavp_vid_ucode_alt.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := tegra12x_xusb_firmware
LOCAL_SRC_FILES            := tegra12x_xusb_firmware
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := fecs
LOCAL_SRC_FILES            := gk20a/fecs.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gk20a
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpccs
LOCAL_SRC_FILES            := gk20a/gpccs.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gk20a
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpmu_ucode
LOCAL_SRC_FILES            := gk20a/gpmu_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gk20a
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := NETB_img
LOCAL_SRC_FILES            := gk20a/NETB_img.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gk20a
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvhost_msenc031
LOCAL_SRC_FILES            := tegra12x/nvhost_msenc031.fw
LOCAL_MODULE_SUFFIX        := .fw
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra12x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvhost_tsec
LOCAL_SRC_FILES            := tegra12x/nvhost_tsec.fw
LOCAL_MODULE_SUFFIX        := .fw
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra12x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vic03_ucode
LOCAL_SRC_FILES            := tegra12x/vic03_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra12x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_ARCH_PREBUILT)
