# Mender Integration Setup Script

. setup-environment $@

echo "BBLAYERS += \" \${OEROOT}/layers/meta-mender-community/meta-mender-96boards \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${OEROOT}/layers/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${OEROOT}/layers/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../layers/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../layers/meta-mender-community/meta-mender-96boards/templates/local.conf.append >> conf/local.conf

echo ""
echo "Mender integration complete."
echo ""
