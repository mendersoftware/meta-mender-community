require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "Small image capable of running the Mender validation suite"

IMAGE_INSTALL:append = " bootloader-validation mender-setup "
IMAGE_FEATURES:append = " allow-empty-password empty-root-password allow-root-login "
