#!/bin/bash
set -e
scriptdir="$(dirname "$(readlink -f "$0")")"
imagesdir=$(realpath ${scriptdir}/../../../../../build/tmp/deploy/images)
echo "Serving images from ${imagesdir}"
pushd ${imagesdir}
python -m SimpleHTTPServer 8080 
