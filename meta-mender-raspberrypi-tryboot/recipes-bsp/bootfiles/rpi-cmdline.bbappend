# Set root partition to placeholder; tryboot-cmdline.bbclass replaces it
# per boot partition with the correct device path during WIC post-processing.
CMDLINE_ROOT_PARTITION = "XXX"
