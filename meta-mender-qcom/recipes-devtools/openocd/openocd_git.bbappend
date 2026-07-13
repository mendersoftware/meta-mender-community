# Enable OpenOCD's linuxgpiod adapter driver so it can bit-bang SWD over
# /dev/gpiochipN via libgpiod. This is how the Uno Q's QRB2210 programs the
# on-board STM32U585 (internal SWD on gpiochip1 lines 25=SWDIO / 26=SWCLK); the
# kernel has no sysfs GPIO, so the stock recipe's sysfsgpio driver is unusable.
#
# NB: OpenOCD at meta-oe's pinned SRCREV uses the libgpiod v1 API (configure
# requires "libgpiod < 2.0"), so this must build against libgpiod 1.6.5, not the
# 2.x default -- pinned via PREFERRED_VERSION in the kas overlay (unoq-mcu.yml).
DEPENDS += "libgpiod"
PACKAGECONFIG[linuxgpiod] = "--enable-linuxgpiod,--disable-linuxgpiod"
PACKAGECONFIG:append = " linuxgpiod"
