# Mender Integration Setup Script
#
# Copyright 2019 NXP
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

. fsl-setup-release.sh $@

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender-community/meta-mender-imx \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-imx/templates/local.conf.append >> conf/local.conf

echo ""
echo "Mender integration complete."
echo ""
