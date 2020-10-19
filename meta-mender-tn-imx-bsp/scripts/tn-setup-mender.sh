# Mender Integration Setup Script
#
# Copyright 2020 Northern.tech

. tn-setup-release.sh $@

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender-community/meta-mender-tn-imx-bsp \"" >> conf/bblayers.conf

cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-tn-imx-bsp/templates/local.conf.append >> conf/local.conf

echo ""
echo "Mender integration complete."
echo ""
