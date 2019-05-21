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

LOCAL_PATH := vendor/nvidia/common

ifeq ($(TARGET_TEGRA_DOLBY),true)
$(call inherit-product, $(LOCAL_PATH)/ipprotect/ipprotect.mk)
endif

ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
$(call inherit-product, $(LOCAL_PATH)/audio/audio.mk)
endif

ifeq ($(TARGET_TEGRA_GPS),brcm)
$(call inherit-product, $(LOCAL_PATH)/gps/gps.mk)
endif

ifeq ($(TARGET_TEGRA_CAMERA),nvcamera)
$(call inherit-product, $(LOCAL_PATH)/camera/nvcamera.mk)
endif

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
$(call inherit-product, $(LOCAL_PATH)/nvcpl/nvcpl.mk)
endif

ifeq ($(TARGET_TEGRA_MODEM),icera)
$(call inherit-product, $(LOCAL_PATH)/icera/icera.mk)
endif

ifeq ($(TARGET_TEGRA_GPU),nvgpu)
$(call inherit-product, $(LOCAL_PATH)/nvgpu/nvgpu.mk)
endif

ifeq ($(TARGET_TEGRA_CEC),nvhdmi)
$(call inherit-product, $(LOCAL_PATH)/hdmi/hdmi.mk)
endif

ifeq ($(TARGET_TEGRA_KEYSTORE),nvkeystore)
$(call inherit-product, $(LOCAL_PATH)/keystore/keystore.mk)
$(call inherit-product, $(LOCAL_PATH)/security/security.mk)
endif

ifeq ($(TARGET_TEGRA_MEMTRACK),nvmemtrack)
$(call inherit-product, $(LOCAL_PATH)/memtrack/memtrack.mk)
endif

ifeq ($(TARGET_TEGRA_OMX),nvmm)
$(call inherit-product, $(LOCAL_PATH)/nvmm/nvmm.mk)
endif

ifeq ($(TARGET_TEGRA_PBC),pbc2)
$(call inherit-product, $(LOCAL_PATH)/pbc/pbc2.mk)
endif

ifeq ($(TARGET_TEGRA_PHS),nvphs)
$(call inherit-product, $(LOCAL_PATH)/nvphs/nvphs.mk)
endif

ifeq ($(TARGET_TEGRA_POWER),nvpower)
$(call inherit-product, $(LOCAL_PATH)/power/power.mk)
endif

ifneq ($(filter $(TARGET_TEGRA_TOUCH), raydium),)
$(call inherit-product, $(LOCAL_PATH)/raydium/raydium.mk)
endif

ifneq ($(filter $(TARGET_TEGRA_TOUCH), sharp),)
$(call inherit-product, $(LOCAL_PATH)/shtouch/shtouch.mk)
endif

ifeq ($(TARGET_TEGRA_WIDEVINE),true)
$(call inherit-product, $(LOCAL_PATH)/widevine/widevine.mk)
endif
