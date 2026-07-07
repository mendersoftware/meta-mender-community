# Uno Q MCU demo: versioned LED blink (out-of-tree Zephyr application).
cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(unoq_mcu_blink C)

# Version + blink period are injected by the Yocto recipe (-D...), with sane
# fallbacks so a standalone `west build -b arduino_uno_q` still works.
if(NOT DEFINED FW_VERSION)
  set(FW_VERSION "unoq-mcu-dev")
endif()
if(NOT DEFINED BLINK_PERIOD_MS)
  set(BLINK_PERIOD_MS 500)
endif()

target_sources(app PRIVATE src/main.c)
target_compile_definitions(app PRIVATE
  FW_VERSION="${FW_VERSION}"
  BLINK_PERIOD_MS=${BLINK_PERIOD_MS}
)
