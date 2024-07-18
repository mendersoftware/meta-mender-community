#! /bin/bash
set -e
scriptdir="$(dirname "$(readlink -f "$0")")"
PROGNAME=$(basename $0)

usage()
{
    cat >&2 <<EOF
Do a mender test
Usage: $PROGNAME --machine <MACHINE> --image <IMAGE> -- <optional args to mender_tegra_test>
Options:
    -h, --h             Print this usage message
    -m, --machine       Set the MACHINE used for this script.
    -i, --image         Set the IMAGE used for this script
    -d, --device        Set the target device hostname or IP address used
                        for the test.  Defaults to MACHINE.local if not
                        specified
    -u, --url		Set the mender install url argument to use with the test
                        Defaults to http://<local machine ip address>:8080/MACHINE/IMAGE-MACHINE.mender if 
                        not specified (based on defaults in setup_image_server.sh)
Examples:
- To kick off a single mender upgrade test for jetson-xavier-nx-devkit
    booted on the local network with name jetson-xavier-nx-devkit.local
    with http server running locally based on setup_image_server.sh
  $ $0 --machine jetson-xavier-nx-devkit  --image demo-image-base
EOF
}

# get command line options
SHORTOPTS="hm:i:d:u:"
LONGOPTS="help,machine:,image:,device:,url:"

ARGS=$(getopt --options $SHORTOPTS --longoptions $LONGOPTS --name $PROGNAME -- "$@" )
if [ $? != 0 ]; then
   usage
   exit 1
fi

eval set -- "$ARGS"
while true;
do
    case $1 in
        -h | --help)       usage; exit 0 ;;
        -m | --machine)    MACHINE="$2"; shift 2;;
        -i | --image)      IMAGE="$2"; shift 2;;
        -d | --device)     DEVICE="$2"; shift 2;;
-u | --url ) 	   MENDER_INSTALL="$2"; shift 2;;
        -- )               shift; break ;;
        * )                break ;;
    esac
done

if [ -z "${MENDER_INSTALL}" ]; then
    if [ -z "$MACHINE" -o -z "$IMAGE" ]; then
        echo "Must specify both machine and image if not specifying mender_install"
        usage
        exit 1
    fi
    MENDER_INSTALL="http://$(hostname -I | awk '{print $1}'):8080/${MACHINE}/${IMAGE}-${MACHINE}.mender"
    echo "Using mender install argument ${MENDER_INSTALL}."
    echo "This assumes you've setup a http mender server locally using"
    echo "setup_image_server.sh or similar commands"
fi

if [ -z "${DEVICE}" ]; then
    if [ -z "$MACHINE" ]; then
        echo "Must specify machine if not specifying device"
        usage
        exit 1
    fi
    DEVICE="${MACHINE}.local"
    echo "Using device ${DEVICE} based on ${MACHINE}.  This assumes you are"
    echo "using the default hostname for ${MACHINE} builds and you are able to"
    echo "resolve .local network names with your network setup.  If you have"
    echo "issues with this try an IP address for device instead"
fi

${scriptdir}/mender_tegra_test.py --device ${DEVICE} --mender_install ${MENDER_INSTALL} $@
