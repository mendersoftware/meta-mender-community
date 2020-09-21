#!/bin/bash
# Mender Integration Setup Script
#
# Authored-by:  Daniel Selvan (daniel.selvan@jasmin-infotech.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Copyright (C) 2020 Jasmin Infotech.

. fsl-setup-release.sh $@

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender-community/meta-mender-imx \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-imx/templates/local.conf.append >> conf/local.conf

echo ""
echo "Mender integration complete."
echo ""
