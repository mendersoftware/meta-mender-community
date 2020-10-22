do_compile() {
	oe_runmake -C ${S} sandbox_defconfig O=${B}
	for config in ${SED_CONFIG_DISABLE}; do
		sed -i -e "s/$config=.*/# $config is not set/" ${B}/.config
	done
	oe_runmake -C ${S} cross_tools NO_SDL=1 O=${B}
}
