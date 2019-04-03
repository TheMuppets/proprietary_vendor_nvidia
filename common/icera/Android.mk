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
LOCAL_MODULE               := icera-switcherd
LOCAL_SRC_FILES            := bin32/icera-switcherd
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libril-icera
LOCAL_SRC_FILES            := lib/libril-icera.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := modemnic
LOCAL_SRC_FILES            := bin/modemnic
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)
