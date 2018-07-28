# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),TRUE)

# Apk
PRODUCT_PACKAGES += \
                    NvCPLSvc \
                    NvShieldTech \
                    TegraZone_Next

# Libs
PRODUCT_PACKAGES += \
    libfirmwareupdate \
    liblota \
    libhidraw \
    libnvcontrol_jni \
    libnvhwc_service \
    libadaptordecoder

ifeq ($(TARGET_ARCH),arm64)
PRODUCT_PACKAGES += \
    libfirmwareupdate_32 \
    liblota_32 \
    libhidraw_32 \
    libnvcontrol_jni_32 \
    libnvhwc_service_32
endif

endif
