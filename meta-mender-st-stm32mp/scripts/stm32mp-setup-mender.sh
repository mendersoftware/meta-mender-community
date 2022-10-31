
# Mender Integration Setup Script

export TEMPLATECONF=${PWD}/layers/meta-st/meta-st-openstlinux/conf/template/

if [[ -z "${BUILDDIR}" ]]; then
    echo ""
    echo "BUILDDIR variable is undefined. Please set before running this script."
    echo ""
    echo "The build directory can be created by running"
    echo "    DISTRO=openstlinux-weston MACHINE=stm32mp1 source layers/meta-st/scripts/envsetup.sh"
    echo ""
    exit 1
fi

cd ${BUILDDIR}

# Mender.io
if ! grep -q "meta-mender" ${BUILDDIR}/conf/bblayers.conf; then
    echo "Adding Mender layers to ${BUILDDIR}/conf/bblayers.conf"
    echo "ADDONSLAYERS += \"\${@'\${OEROOT}/layers/meta-mender/meta-mender-core' if os.path.isfile('\${OEROOT}/layers/meta-mender/meta-mender-core/conf/layer.conf') else ''}\"" >> ${BUILDDIR}/conf/bblayers.conf
    echo "ADDONSLAYERS += \"\${@'\${OEROOT}/layers/meta-mender/meta-mender-demo' if os.path.isfile('\${OEROOT}/layers/meta-mender/meta-mender-demo/conf/layer.conf') else ''}\"" >> ${BUILDDIR}/conf/bblayers.conf
    echo "ADDONSLAYERS += \"\${@'\${OEROOT}/layers/meta-mender-st-stm32mp' if os.path.isfile('\${OEROOT}/layers/meta-mender-st-stm32mp/conf/layer.conf') else ''}\"" >> ${BUILDDIR}/conf/bblayers.conf
fi

if ! grep -q "meta-mender" ${BUILDDIR}/conf/local.conf; then
    echo "Adding Mender configurations to ${BUILDDIR}/conf/local.conf"
    cat ../layers/meta-mender-st-stm32mp/templates/local.conf.append >> ${BUILDDIR}/conf/local.conf
fi

# STRATIS workaround instead of also having to manage meta-mender-core
sed -i 's@${DEPLOY_DIR_IMAGE}/uboot.env@${DEPLOY_DIR_IMAGE}/u-boot/uboot.env@g' ../layers/meta-mender/meta-mender-core/classes/mender-part-images.bbclass

echo ""
echo "Mender integration complete."
echo ""
