#!/bin/bash
machine=jetson-tx2
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
deployfile=core-image-base-${machine}.tegraflash.zip
tmpdir=`mktemp`
rm -rf $tmpdir
mkdir -p $tmpdir
echo "Using temp directory $tmpdir"
pushd $tmpdir
cp $scriptdir/build/tmp/deploy/images/${machine}/$deployfile .
unzip $deployfile
set -e
sudo ./doflash.sh
popd
echo "Removing temp directory $tmpdir"
rm -rf $tmpdir
