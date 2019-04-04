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

T18X_XUSB_SYMLINK := $(TARGET_OUT_VENDOR)/firmware/tegra18x_xusb_firmware
$(T18X_XUSB_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	$(hide) ln -sf ./xusb/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(T18X_XUSB_SYMLINK)

include $(CLEAR_VARS)
LOCAL_MODULE               := tegra18x_xusb_firmware
LOCAL_SRC_FILES            := xusb/tegra18x_xusb_firmware
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/xusb
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := acr_ucode
LOCAL_SRC_FILES            := gp10b/acr_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := fecs
LOCAL_SRC_FILES            := gp10b/fecs.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := fecs_sig
LOCAL_SRC_FILES            := gp10b/fecs_sig.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpccs
LOCAL_SRC_FILES            := gp10b/gpccs.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpccs_sig
LOCAL_SRC_FILES            := gp10b/gpccs_sig.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpmu_ucode
LOCAL_SRC_FILES            := gp10b/gpmu_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpmu_ucode_desc
LOCAL_SRC_FILES            := gp10b/gpmu_ucode_desc.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpmu_ucode_image
LOCAL_SRC_FILES            := gp10b/gpmu_ucode_image.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gpu2cde
LOCAL_SRC_FILES            := gp10b/gpu2cde.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := NETA_img
LOCAL_SRC_FILES            := gp10b/NETA_img.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := pmu_bl
LOCAL_SRC_FILES            := gp10b/pmu_bl.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := pmu_sig
LOCAL_SRC_FILES            := gp10b/pmu_sig.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/gp10b
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvhost_nvdec030_ns
LOCAL_SRC_FILES            := tegra18x/nvhost_nvdec030_ns.fw
LOCAL_MODULE_SUFFIX        := .fw
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra18x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvhost_nvenc061
LOCAL_SRC_FILES            := tegra18x/nvhost_nvenc061.fw
LOCAL_MODULE_SUFFIX        := .fw
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra18x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := nvhost_nvjpg011
LOCAL_SRC_FILES            := tegra18x/nvhost_nvjpg011.fw
LOCAL_MODULE_SUFFIX        := .fw
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra18x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vic04_ucode
LOCAL_SRC_FILES            := tegra18x/vic04_ucode.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/tegra18x
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_PREBUILT)
