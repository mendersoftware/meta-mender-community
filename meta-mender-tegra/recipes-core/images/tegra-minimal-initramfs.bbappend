# Prevents circular dependency on u-boot due to EXTRA_IMAGEDEPENDS.
# See https://hub.mender.io/t/warrior-tegra-build-cicular-dependencies/757/5 and comments from Mirza
EXTRA_IMAGEDEPENDS_remove = "u-boot"
