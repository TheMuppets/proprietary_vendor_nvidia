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
LOCAL_MODULE               := NvShieldTech
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := app/NvShieldTech.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE    := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.shieldtech.inputflinger@2.0-service
LOCAL_SRC_FILES_64         := bin64/hw/vendor.nvidia.hardware.shieldtech.inputflinger@2.0-service
LOCAL_MULTILIB             := 64
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.shieldtech.inputflinger@2.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.shieldtech.rpx@1.0-service
LOCAL_SRC_FILES_32         := bin32/hw/vendor.nvidia.hardware.shieldtech.rpx@1.0-service
LOCAL_SRC_FILES_64         := bin64/hw/vendor.nvidia.hardware.shieldtech.rpx@1.0-service
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.shieldtech.rpx@1.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := com.nvidia.shieldtech.xml
LOCAL_SRC_FILES            := etc/permissions/com.nvidia.shieldtech.xml
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := privapp-permissions-nvidia-shieldtech.xml
LOCAL_SRC_FILES            := etc/permissions/privapp-permissions-nvidia-shieldtech.xml
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)
