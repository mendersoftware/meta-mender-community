# Tegra Mender Torture Tests

To help find problems with tegra redundant boot +mender integration
the scrips in this directory can perform testing on mender based targets.

The scripts currently only support cboot based targets, see [this pr](https://github.com/BoulderAI/meta-mender-community/pull/1)
for a discussion of additional complexities to support uboot based targets.

# Setup Python

Run 
```
pip3 install -r requirements.txt
```

## Setup http server

If using tegra-demo-distro layout you can set this up with the 
`meta-mender-tegra/scripts/test/setup_image_server.sh` script.
If using a different layout, use this as an example with the detail below.

The tests require a http server hosting a .mender update file.

Start a simple http server on a httpserver machine like this, running in 
the directory where the mender image is located (or any directory above it).
```
python -m SimpleHTTPServer 8080
```
You'll want to run this in a different terminal window or screen session.


## Running the command

If using tegra-demo-distro layout you can invoke with the
`meta-mender-tegra/scripts/test/do_mender_test.sh` script.
If using a different layout, use this script as an example with the detail below.

Execute a command like this to start the mender test, replacing arguments as needed
```
export devicename=<hostname of target, default of MACHINE, with suffix .local>
export httpserver=<IP of server running SimpleHTTPServer>
export menderfile=<path to mender file relative to location where SimpleHTTPServer is started>
export logfile=/tmp/mender-tegra-torture.log
./mender_tegra_test.py --device ${devicename} --install http://${httpserver}:8080/${menderfile} 2>&1 | tee -a ${logfile}
```

If testing on a production target where an SSH key is required, use the `--key <path to ssh key>` arguement
to specify the key to use for ssh connectivity.

The script repeats the steps below 10 times
* Standalone mender updates 10 times in a row, ensuring boot slot changes with each reboot.
* Reboots 20 times in a row, ensuring the boot slot does not change.

The end result should be 100 mender updates interleaved with 200 reboots.
