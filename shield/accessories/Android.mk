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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE               := AccessoryUiTv
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/AccessoryUiTv.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := NvAccessories
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/NvAccessories.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libhidraw libfirmwareupdate
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := NvCustomize
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/NvCustomize.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
include $(BUILD_NVIDIA_PREBUILT)

# This service handles things not accessible by a vendor service
include $(CLEAR_VARS)
LOCAL_MODULE               := NvAccProxy
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/NvAccProxy.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE    := true
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := NvShieldService
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/NvShieldService.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := lota
LOCAL_SRC_FILES_32         := bin32/lota
LOCAL_SRC_FILES_64         := bin64/lota
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libfirmwareupdate
LOCAL_SRC_FILES_32         := lib/libfirmwareupdate.so
LOCAL_SRC_FILES_64         := lib64/libfirmwareupdate.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libhidraw
LOCAL_SRC_FILES_32         := lib/libhidraw.so
LOCAL_SRC_FILES_64         := lib64/libhidraw.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := privapp-permissions-nvidia-nvaccessories.xml
LOCAL_SRC_FILES            := etc/permissions/privapp-permissions-nvidia-nvaccessories.xml
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)
