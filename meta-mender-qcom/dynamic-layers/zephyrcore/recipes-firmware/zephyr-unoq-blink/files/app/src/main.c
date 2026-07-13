/*
 * Uno Q MCU demo firmware: a versioned LED blink for the on-board STM32U585.
 *
 * FW_VERSION and BLINK_PERIOD_MS are injected at build time by the Yocto recipe
 * (see CMakeLists.txt), so v1/v2 differ only by recipe variables.
 *
 * fw_version[] is kept in its own .rodata section and marked "used" so it
 * survives link-time garbage collection. The Mender "zephyr-mcu" update module
 * reads this marker back over SWD (OpenOCD) to verify which firmware is running,
 * without needing a Linux-side comms channel to the MCU. The "UNOQMCU:" tag
 * makes it trivial to locate in a raw flash dump.
 */
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/sys/printk.h>

#ifndef FW_VERSION
#define FW_VERSION "unoq-mcu-dev"
#endif
#ifndef BLINK_PERIOD_MS
#define BLINK_PERIOD_MS 500
#endif

__attribute__((used, section(".rodata.fw_version")))
const char fw_version[] = "UNOQMCU:" FW_VERSION;

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led0), gpios);

int main(void)
{
	printk("unoq-mcu firmware %s (blink %d ms)\n", fw_version, BLINK_PERIOD_MS);

	if (!gpio_is_ready_dt(&led)) {
		printk("unoq-mcu: led0 not ready\n");
		return 0;
	}
	if (gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE) < 0) {
		printk("unoq-mcu: led0 configure failed\n");
		return 0;
	}

	while (1) {
		gpio_pin_toggle_dt(&led);
		k_msleep(BLINK_PERIOD_MS);
	}
	return 0;
}
