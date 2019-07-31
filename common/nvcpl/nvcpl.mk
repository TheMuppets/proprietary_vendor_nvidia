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

NVCPL_PATH := vendor/nvidia/common/nvcpl

PRODUCT_PACKAGES += \
    NvCPLSvc \
    vendor.nvidia.hardware.cpl.service@1.0-service

PRODUCT_COPY_FILES += \
    $(NVCPL_PATH)/system/lib/vendor.nvidia.hardware.cpl.interfacecb@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib/vendor.nvidia.hardware.cpl.interfacecb@1.0.so \
    $(NVCPL_PATH)/system/lib/vendor.nvidia.hardware.cpl.service@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib/vendor.nvidia.hardware.cpl.service@1.0.so \
    $(NVCPL_PATH)/system/lib/vendor.nvidia.hardware.cpl.tools@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib/vendor.nvidia.hardware.cpl.tools@1.0.so \
    $(NVCPL_PATH)/system/lib/libnvcpl.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libnvcpl.so \
    $(NVCPL_PATH)/system/lib/libnvcpl_vendor.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libnvcpl_vendor.so

ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_COPY_FILES += \
    $(NVCPL_PATH)/system/lib64/vendor.nvidia.hardware.cpl.interfacecb@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/vendor.nvidia.hardware.cpl.interfacecb@1.0.so \
    $(NVCPL_PATH)/system/lib64/vendor.nvidia.hardware.cpl.service@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/vendor.nvidia.hardware.cpl.service@1.0.so \
    $(NVCPL_PATH)/system/lib64/vendor.nvidia.hardware.cpl.tools@1.0.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/vendor.nvidia.hardware.cpl.tools@1.0.so \
    $(NVCPL_PATH)/system/lib64/libnvcpl.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libnvcpl.so \
    $(NVCPL_PATH)/system/lib64/libnvcpl_vendor.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libnvcpl_vendor.so
endif
