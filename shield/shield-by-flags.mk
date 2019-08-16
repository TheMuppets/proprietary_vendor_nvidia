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

LOCAL_PATH := vendor/nvidia/shield

ifeq ($(NV_ANDROID_SHIELDTECH_ENHANCEMENTS),true)
$(call inherit-product, $(LOCAL_PATH)/shieldtech/shieldtech.mk)
endif

ifeq ($(NV_ANDROID_BEYONDER_ENHANCEMENTS),true)
$(call inherit-product, $(LOCAL_PATH)/beyonder/beyonder.mk)
endif

ifeq ($(TARGET_TEGRA_VARIANT),shield)
#$(call inherit-product, $(LOCAL_PATH)/flynn/flynn.mk)
endif

ifeq ($(NV_ANDROID_SHIELDTECH_ENHANCEMENTS),true)
$(call inherit-product, $(LOCAL_PATH)/accessories/nvaccessories.mk)
endif

ifeq ($(TARGET_TEGRA_VARIANT),shield)
ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
$(call inherit-product, $(LOCAL_PATH)/TegraZone/tegrazone.mk)
endif
endif
