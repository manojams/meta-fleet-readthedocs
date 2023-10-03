FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

SRC_URI = "\
    file://emmcsetup.lua \
    file://sw-description \
"

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "core-image-full-cmdline"

COMPATIBLE_MACHINE = "neu6b-fleet|neu6b-up-fleet"
