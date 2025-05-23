$(call inherit-product, vendor/miuicamera/common/common-vendor.mk)

# props
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.miui.notch=1 \
    ro.com.google.lens.oem_camera_package=com.android.camera \
    persist.vendor.camera.privapp.list=com.android.camera

# Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    vendor/miuicamera/sepolicy/private
