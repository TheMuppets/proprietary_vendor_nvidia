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

# AVP firmware
PRODUCT_PACKAGES += \
    nvavp_aud_ucode \
    nvavp_os_0ff00000 \
    nvavp_os_eff00000 \
    nvavp_vid_ucode_alt

# General firmware
PRODUCT_PACKAGES += \
    nvhost_msenc02 \
    nvhost_tsec

# Oemcrypto
ifeq ($(TARGET_TEGRA_WIDEVINE),true)
PRODUCT_PACKAGES += liboemcrypto
endif
