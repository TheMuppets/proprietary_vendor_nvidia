GCC_HOST_BINARIES:=$(wildcard prebuilts/gcc/linux-x86/host/x86_64-linux-*/x86_64-linux/bin)
LOCAL_SHARED_LIBRARIES += $(shell (basename -s .so `$(GCC_HOST_BINARIES)/objdump -x $(LOCAL_PATH)/$(LOCAL_SRC_FILES) 2>/dev/null |grep NEEDED` 2>/dev/null |grep -v ^NEEDED$ |tr '\n' ' '))
LOCAL_SHARED_LIBRARIES += $(shell (basename -s .so `$(GCC_HOST_BINARIES)/objdump -x $(LOCAL_PATH)/$(LOCAL_SRC_FILES_32) 2>/dev/null |grep NEEDED` 2>/dev/null |grep -v ^NEEDED$ |tr '\n' ' '))
LOCAL_SHARED_LIBRARIES += $(shell (basename -s .so `$(GCC_HOST_BINARIES)/objdump -x $(LOCAL_PATH)/$(LOCAL_SRC_FILES_64) 2>/dev/null |grep NEEDED` 2>/dev/null |grep -v ^NEEDED$ |tr '\n' ' '))

include $(BUILD_PREBUILT)
