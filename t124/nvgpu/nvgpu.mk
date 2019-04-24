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

PRODUCT_PACKAGES += \
                    android.hardware.graphics.allocator@2.0-impl \
                    android.hardware.graphics.allocator@2.0-service \
                    android.hardware.graphics.composer@2.1-impl \
                    android.hardware.graphics.mapper@2.0-impl \
                    gralloc.tegra \
                    hwcomposer.tegra \
                    vulkan.nvgpu \
                    libEGL_tegra \
                    libGLESv1_CM_tegra \
                    libGLESv2_tegra \
                    libnvwsi \
                    libcuda \
                    com.nvidia.feature.opengl4.xml \
                    com.nvidia.nvsi.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    persist.tegra.compositor=glcomposer \
    persist.tegra.decompression=cde-client \
    ro.hardware.vulkan=nvgpu \
    debug.sf.latch_unsignaled=1 \
    debug.sf.disable_backpressure=1 \
    persist.tegra.compositor=gldrawtexture
