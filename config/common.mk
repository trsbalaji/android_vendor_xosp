PRODUCT_BRAND ?= XOSP



PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/xosp/README.mkdn:system/etc/Changelog.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xosp/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xosp/prebuilt/common/bin/50-xosp.sh:system/addon.d/50-xosp.sh \
    vendor/xosp/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/xosp/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Bootanimation 
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip
    
# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is XOSP
PRODUCT_COPY_FILES += \
    vendor/xosp/config/permissions/com.xosp.android.xml:system/etc/permissions/com.xosp.android.xml

# Viper
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/apps/MaterialDarkV4A.apk:system/priv-app/MaterialDarkV4A/MaterialDarkV4A.apk \
    vendor/xosp/prebuilt/common/addon.d/23-v4a.sh:system/addon.d/23-v4a.sh \
    vendor/xosp/prebuilt/common/lib/soundfx/libeffectproxy.so:system/lib/soundfx/libeffectproxy.so \
    vendor/xosp/prebuilt/common/lib/soundfx/libv4a_fx_ics.so:system/lib/soundfx/libv4a_fx_ics.so \
    vendor/xosp/prebuilt/common/su.d/50viper.sh:system/su.d/50viper.sh 

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/xosp/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/xosp/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Theme engine
include vendor/xosp/config/themes_common.mk

# CMSDK
include vendor/xosp/config/cmsdk_common.mk

PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    Profiles

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    XOSPFileManager \
    LockClock \
    CMSettingsProvider \
    ExactCalculator \
    CMSettingsProvider \
    XOSPSetupWizard \
    LiveWallpapersPicker 

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1

PRODUCT_PACKAGE_OVERLAYS += vendor/xosp/overlay/common

PRODUCT_RELEASE = RL5
PRODUCT_REVISION = 2
PRODUCT_REVISION_PROP = Revision2
XOSP_APPS_CHECK = true
BUILD_MAJOR=5
BUILD_MINOR=2

ifndef XOSP_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "XOSP_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^XOSP_||g')
        XOSP_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif
        
ifeq ($(XOSP_BUILDTYPE), OFFICIAL)
        XOSP_VERSION := XOSP-$(BUILD_MAJOR).$(BUILD_MINOR)-$(XOSP_BUILDTYPE)-$(shell date -u +%Y%m%d)-$(XOSP_BUILD)
        
        #Build XOSPOTA if the target product is an official one
			PRODUCT_PACKAGES += \
			XOSPOTA

else
    # If XOSP_BUILDTYPE is not defined, set to UNOFFICIAL
    XOSP_BUILDTYPE := UNOFFICIAL
		  XOSP_VERSION := XOSP-$(BUILD_MAJOR).$(BUILD_MINOR)-$(XOSP_BUILDTYPE)-$(shell date -u +%Y%m%d)-$(XOSP_BUILD)
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.mod.version=$(XOSP_VERSION) \
  ro.xosp.releasetype=$(XOSP_BUILDTYPE) \
  ro.xosp.release=$(PRODUCT_RELEASE) \
  ro.xosp.revision=$(PRODUCT_REVISION_PROP) \
  ro.xosp.apps=$(XOSP_APPS_CHECK) \
  ro.modversion=$(XOSP_VERSION) \
  ro.cmlegal.url=https://cyngn.com/legal/privacy-policy

-include vendor/xosp-priv/keys/keys.mk

XOSP_DISPLAY_VERSION := $(XOSP_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.xosp.display.version=$(XOSP_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
