#!/usr/bin/env python3
import fabric2
from fabric2 import Connection
import argparse
import time
import traceback
import sys
import re
import subprocess
import platform
import textwrap
from device_test import DeviceTest

class MenderTegraTest(DeviceTest):
   
    def get_parser(self):
        if self.argparser is None:
            argparser=super().get_parser("mender_tegra_tests.py","Tests mender functionality on tegra devices")
  
            argparser.add_argument('-m',
                                   '--mender_install',
                                   help=textwrap.dedent('''\
                                        The mender install argument to use with standalone install,
                                        for instance, http://mylocalserver:8080/machine/imagename.mender
                                        where you've used setup_image_server.sh to setup your image
                                        server in your build/tmp/deploy/images directory or set this
                                        up manually yourself.'''))

            argparser.add_argument('-t',
                                   '--test',
                                   help=textwrap.dedent('''\
                                        The test to run.  Options are:
                                            single [default] - run a single mender update
                                            mender_torture - run the mender torture test
                                            reboot_torture - run the reboot torture test'''))

        return self.argparser

    def mender_install(self):
        args = self.get_args()
        conn = self.get_connection()
        if args.mender_install is None:
            self.get_parser().print_help()
            print("Missing argument install")
            raise RuntimeError("Missing argument mender_install")
        result = conn.run(f"mender -install {args.mender_install}")
        # Mender doesn't return error states, so we can't check return codes here
        match = re.search(r' level=error ', result.stderr, re.MULTILINE)
        if match is not None:
            raise RuntimeError("Mender install failed with error messages in the logs")

    def add_sentinel_file(self):
        conn = self.get_connection()
        conn.run("mkdir -p /var/lib/mender")
        conn.run("touch /var/lib/mender/dont-mark-next-boot-successful")

    def mender_commit(self):
        self.get_connection().run("mender -commit")

    def reboot(self):
        conn = self.get_connection()
        print("Rebooting device")
        result = conn.run("reboot", warn=True)
        self.wait_for_device_removal()
        self.wait_for_device()

    def nvbootctrl_current_slot(self):
        conn = self.get_connection()
        result = conn.run("nvbootctrl get-current-slot", hide=True)
        return result.stdout.strip()

    def check_partition_mismatch(self):
        conn = self.get_connection()
        boot_slot = self.nvbootctrl_current_slot()
        rootfs_part = None
        if boot_slot == '0':
            rootfs_part = 'RootfsPartA'
        elif boot_slot == '1':
            rootfs_part = 'RootfsPartB'

        if rootfs_part != None:
            blockdev_result = conn.run(f'grep -h {rootfs_part} /etc/mender/mender.conf /var/lib/mender/mender.conf | cut -d: -f2 | cut -d, -f1 | tr -d \'" \'')
            result = conn.run(f'df -h | grep {blockdev_result.stdout.strip()}')
            if result.return_code != 0:
                raise RuntimeError(f"Boot and Rootfs Partition Mismatch detected, rootfs should be mounted to {blockdev_result} for boot slot {boot_slot}")
        else:
            raise RuntimeError("Cannot Identify Rootfs Partition Slot")


    def do_mender_update(self):
        # Connecting to the device
        print("Starting mender update")
        self.wait_for_device()
        prev_machine_id = self.get_machine_id()
        # mender install 
        self.mender_install()
        # Check Partition Mismatch
        self.check_partition_mismatch()
        # Get current boot slot after mender update and before reboot
        prev_boot_slot = self.nvbootctrl_current_slot()
        # reboot the device
        self.reboot()
        # Getting current_boot_slot after reboot
        current_boot_slot = self.nvbootctrl_current_slot()
        current_machine_id = self.get_machine_id()
        # Check if update was successful after reboot
        if prev_boot_slot == current_boot_slot:
            raise RuntimeError("Mender Install successful but slot change not reflected after reboot")
        if current_machine_id != prev_machine_id:
            raise RuntimeError(f"machine ID changed from {prev_machine_id} to {current_machine_id} during mender update")
        print(f"Mender update applied successfully with expected boot slot change from" \
                f" {prev_boot_slot} to {current_boot_slot} and no change in machine ID {current_machine_id}")
        return current_boot_slot

    '''
    This test isn't currently supported.  We'd need a way to prevent the startup script from marking successful
    boot in order to prove rollback is happening
    '''
    def check_rollback(self):
        print("****************************************")
        print("Starting test case")
        expected_rollback_reboots=7
        boot_slot = self.mender_install()
        for i in range(expected_rollback_reboots):
            # Check Partition Mismatch
            self.check_partition_mismatch()
            # check the current boot_slot
            if boot_slot != self.nvbootctrl_current_slot():
                raise RuntimeError("Mender Rollback occurred earlier than expected")
            self.reboot()
        # Device expected to rollback here
        if boot_slot != self.nvbootctrl_current_slot():
            print(f"Success: Rollback after {expected_rollback_reboots} reboots")
        else:
            raise RuntimeError(f"ERROR: No rollback after {expected_rollback_reboots} reboots")

    def do_mender_torture(self):
        """
        Do 10 mender updates in a row followed by 20 reboots, then repeat the
        entire loop 10 times
        """
        big_loops = 10
        mender_updates_per_loop = 10
        reboots_per_loop = 20
        print(f"Starting mender torture tests with {big_loops} loops of {mender_updates_per_loop} mender updates" \
                f" followed by {reboots_per_loop} reboots")
        boot_slot = None
        for bigloop in range (big_loops):
            for i in range (mender_updates_per_loop):
                print(f"Starting mender update {mender_updates_per_loop*bigloop+i+1}")
                boot_slot = self.do_mender_update()
            for i in range (reboots_per_loop):
                print(f"Starting reboot {reboots_per_loop*bigloop+i+1}")
                prev_boot_slot = self.nvbootctrl_current_slot()
                self.reboot()
                boot_slot = self.nvbootctrl_current_slot()
                if boot_slot != prev_boot_slot:
                    raise RuntimeError(f"Boot slot changed from {prev_boot_slot} to {boot_slot} after {i} reboots on iteration {bigloop}")
          
    def do_reboot_torture(self):
        """
        Do 200 reboots, making sure boot slot doesn't change
        """
        num_reboots=100
        print(f"Starting reboot torture tests with {num_reboots} reboots")
        boot_slot = None
        for i in range (num_reboots):
            print("Starting reboot {}".format(i))
            prev_boot_slot = self.nvbootctrl_current_slot()
            self.reboot()
            boot_slot = self.nvbootctrl_current_slot()
            if boot_slot != prev_boot_slot:
                raise RuntimeError(f"Boot slot changed from {prev_boot_slot} to {boot_slot} after {i} reboots")
    
    def do_test(self):
        print("Starting test")
        args = self.get_args()
        test = args.test
        ret = 0
        if test is None:
            print("No test specified, using single test type")
            test = "single"
        if test == "single":
            print("Starting single mender install test")
            self.do_mender_update()
        elif test == "mender_torture":
            self.do_mender_torture()
        elif test == "reboot_torture":
            self.do_reboot_torture()
        else:
            ret = -1
            self.get_parser().print_help()
            print(f"Unsupported test argument {test}")
        return ret

if __name__ == '__main__':
    test = MenderTegraTest()
    sys.exit(test.do_test())
