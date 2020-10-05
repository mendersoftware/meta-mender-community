#!/bin/bash
# Set your machine type here
machine=jetson-tx2
# Set your image type here
image=demo-image-base
echo "Using machine ${machine} image ${image}"
deployfile=${image}-${machine}.tegraflash.tar.gz
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
tmpdir=`mktemp`
rm -rf $tmpdir
mkdir -p $tmpdir
echo "Using temp directory $tmpdir"
pushd $tmpdir
cp $scriptdir/../../../../build/tmp/deploy/images/${machine}/$deployfile .
tar -xvf $deployfile
set -e
sudo ./doflash.sh
popd
echo "Removing temp directory $tmpdir"
rm -rf $tmpdir
