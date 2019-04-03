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
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.composer@2.0-service
LOCAL_SRC_FILES_32         := bin32/hw/vendor.nvidia.hardware.graphics.composer@2.0-service
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES_64         := bin64/hw/vendor.nvidia.hardware.graphics.composer@2.0-service
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.graphics.composer@2.0-service.rc
else
LOCAL_SRC_FILES_64         := bin64/hw/vendor.nvidia.hardware.graphics.composer@2.0-service.nodolby
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.graphics.composer@2.0-service.nodolby.rc
endif
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gralloc.tegra
LOCAL_SRC_FILES_32         := lib/hw/gralloc.tegra.so
LOCAL_SRC_FILES_64         := lib64/hw/gralloc.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vulkan.tegra
LOCAL_SRC_FILES_32         := lib/hw/vulkan.tegra.so
LOCAL_SRC_FILES_64         := lib64/hw/vulkan.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libEGL_tegra
LOCAL_SRC_FILES_32         := lib/egl/libEGL_tegra.so
LOCAL_SRC_FILES_64         := lib64/egl/libEGL_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libGLESv1_CM_tegra
LOCAL_SRC_FILES_32         := lib/egl/libGLESv1_CM_tegra.so
LOCAL_SRC_FILES_64         := lib64/egl/libGLESv1_CM_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libGLESv2_tegra
LOCAL_SRC_FILES_32         := lib/egl/libGLESv2_tegra.so
LOCAL_SRC_FILES_64         := lib64/egl/libGLESv2_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libdolbycontrol
LOCAL_SRC_FILES_32         := lib/libdolbycontrol.so
LOCAL_SRC_FILES_64         := lib64/libdolbycontrol.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libglcore
LOCAL_SRC_FILES_32         := lib/libglcore.so
LOCAL_SRC_FILES_64         := lib64/libglcore.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := com.nvidia.feature.opengl4.xml com.nvidia.nvsi.xml
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libmempoollocal
LOCAL_SRC_FILES_32         := lib/libmempoollocal.so
LOCAL_SRC_FILES_64         := lib64/libmempoollocal.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvblit
LOCAL_SRC_FILES_32         := lib/libnvblit.so
LOCAL_SRC_FILES_64         := lib64/libnvblit.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvddk_2d_v2
LOCAL_SRC_FILES_32         := lib/libnvddk_2d_v2.so
LOCAL_SRC_FILES_64         := lib64/libnvddk_2d_v2.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvddk_vic
LOCAL_SRC_FILES_32         := lib/libnvddk_vic.so
LOCAL_SRC_FILES_64         := lib64/libnvddk_vic.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvglsi
LOCAL_SRC_FILES_32         := lib/libnvglsi.so
LOCAL_SRC_FILES_64         := lib64/libnvglsi.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libnvwsi
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvgr
LOCAL_SRC_FILES_32         := lib/libnvgr.so
LOCAL_SRC_FILES_64         := lib64/libnvgr.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvhwcomposer
LOCAL_REQUIRED_MODULES     := libcuda
LOCAL_SRC_FILES_32         := lib/libnvhwcomposer.so
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES_64         := lib64/libnvhwcomposer.so
LOCAL_REQUIRED_MODULES     += libdolbycontrol
else
LOCAL_SRC_FILES_64         := lib64/libnvhwcomposer.nodolby.so
endif
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvidia-glvkspirv
LOCAL_SRC_FILES_32         := lib/libnvidia-glvkspirv.so
LOCAL_SRC_FILES_64         := lib64/libnvidia-glvkspirv.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrmapi_tegra
LOCAL_SRC_FILES_32         := lib/libnvrmapi_tegra.so
LOCAL_SRC_FILES_64         := lib64/libnvrmapi_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_graphics
LOCAL_SRC_FILES_32         := lib/libnvrm_graphics.so
LOCAL_SRC_FILES_64         := lib64/libnvrm_graphics.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_gpu
LOCAL_SRC_FILES_32         := lib/libnvrm_gpu.so
LOCAL_SRC_FILES_64         := lib64/libnvrm_gpu.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm
LOCAL_SRC_FILES_32         := lib/libnvrm.so
LOCAL_SRC_FILES_64         := lib64/libnvrm.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrmvkif
LOCAL_SRC_FILES_32         := lib/libnvrmvkif.so
LOCAL_SRC_FILES_64         := lib64/libnvrmvkif.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvwsi
LOCAL_SRC_FILES_32         := lib/libnvwsi.so
LOCAL_SRC_FILES_64         := lib64/libnvwsi.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvcolorutil
LOCAL_SRC_FILES_32         := lib/libnvcolorutil.so
LOCAL_SRC_FILES_64         := lib64/libnvcolorutil.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvdc
LOCAL_SRC_FILES_32         := lib/libnvdc.so
LOCAL_SRC_FILES_64         := lib64/libnvdc.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvimp
LOCAL_SRC_FILES_32         := lib/libnvimp.so
LOCAL_SRC_FILES_64         := lib64/libnvimp.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libcuda
LOCAL_SRC_FILES_32         := lib/libcuda.so
LOCAL_SRC_FILES_64         := lib64/libcuda.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvidia-fatbinaryloader
LOCAL_SRC_FILES_32         := lib/libnvidia-fatbinaryloader.so
LOCAL_SRC_FILES_64         := lib64/libnvidia-fatbinaryloader.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libnvidia-ptxjitcompiler
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvidia-ptxjitcompiler
LOCAL_SRC_FILES_32         := lib/libnvidia-ptxjitcompiler.so
LOCAL_SRC_FILES_64         := lib64/libnvidia-ptxjitcompiler.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.composer@2.0-impl
LOCAL_SRC_FILES_32         := lib/vendor.nvidia.hardware.graphics.composer@2.0-impl.so
LOCAL_SRC_FILES_64         := lib64/vendor.nvidia.hardware.graphics.composer@2.0-impl.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.display@1.0-impl
LOCAL_SRC_FILES_32         := lib/vendor.nvidia.hardware.graphics.display@1.0-impl.so
LOCAL_SRC_FILES_64         := lib64/vendor.nvidia.hardware.graphics.display@1.0-impl.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.mempool@1.0
LOCAL_SRC_FILES_32         := lib/vendor.nvidia.hardware.graphics.mempool@1.0.so
LOCAL_SRC_FILES_64         := lib64/vendor.nvidia.hardware.graphics.mempool@1.0.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.mempool@1.0-impl
LOCAL_SRC_FILES_32         := lib/vendor.nvidia.hardware.graphics.mempool@1.0-impl.so
LOCAL_SRC_FILES_64         := lib64/vendor.nvidia.hardware.graphics.mempool@1.0-impl.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := com.nvidia.feature.opengl4.xml
LOCAL_SRC_FILES            := etc/permissions/com.nvidia.feature.opengl4.xml
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)
