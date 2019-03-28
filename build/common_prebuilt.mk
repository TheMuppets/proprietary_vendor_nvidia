ifneq ("$(LOCAL_SRC_FILES)","")
NVIDIA_SRC_FILES := $(LOCAL_SRC_FILES)
else ifneq ("$(LOCAL_SRC_FILES_32)","")
NVIDIA_SRC_FILES := $(LOCAL_SRC_FILES_32)
else ifneq ("$(LOCAL_SRC_FILES_64)","")
NVIDIA_SRC_FILES := $(LOCAL_SRC_FILES_64)
endif

ifeq ("$(wildcard vendor/nvidia/$(TARGET_TEGRA_VERSION)/$(notdir $(LOCAL_PATH))/$(NVIDIA_SRC_FILES))","")
ifeq ("$(wildcard vendor/nvidia/$(TARGET_TEGRA_DEVICE)/$(notdir $(LOCAL_PATH))/$(NVIDIA_SRC_FILES))","")
include $(BUILD_NVIDIA_PREBUILT)
endif
endif
