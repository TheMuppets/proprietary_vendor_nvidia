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

COMMON_PATH := vendor/nvidia/common

ifeq ($(TARGET_TEGRA_DOLBY),true)
include $(COMMON_PATH)/ipprotect/BoardIPProtect.mk
endif

ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
include $(COMMON_PATH)/audio/BoardAudio.mk
endif

ifeq ($(TARGET_TEGRA_CAMERA),nvcamera)
include $(COMMON_PATH)/camera/BoardCamera.mk
endif

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
include $(COMMON_PATH)/nvcpl/BoardCPL.mk
endif

ifeq ($(TARGET_TEGRA_GPU),nvgpu)
include $(COMMON_PATH)/nvgpu/BoardNvgpu.mk
endif

ifeq ($(TARGET_TEGRA_CEC),nvhdmi)
include $(COMMON_PATH)/hdmi/BoardHdmi.mk
endif

ifeq ($(TARGET_TEGRA_GPS),brcm)
include $(COMMON_PATH)/gps/BoardGps.mk
endif

ifeq ($(TARGET_TEGRA_KEYSTORE),nvkeystore)
include $(COMMON_PATH)/keystore/BoardKeystore.mk
endif

ifeq ($(TARGET_TEGRA_MEMTRACK),nvmemtrack)
include $(COMMON_PATH)/memtrack/BoardMemtrack.mk
endif

ifeq ($(TARGET_TEGRA_OMX),nvmm)
include $(COMMON_PATH)/nvmm/BoardNvmm.mk
endif

ifeq ($(TARGET_TEGRA_PHS),nvphs)
include $(COMMON_PATH)/nvphs/BoardPhs.mk
endif

ifeq ($(TARGET_TEGRA_POWER),nvpower)
include $(COMMON_PATH)/power/BoardPower.mk
endif

ifeq ($(TARGET_TEGRA_WIDEVINE),true)
include $(COMMON_PATH)/widevine/BoardWidevine.mk
endif
