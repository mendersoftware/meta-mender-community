import fabric2
from fabric2 import Connection
import argparse
import time
import traceback
import sys
import re
import subprocess
import platform
from device_test import DeviceTest

class MenderTegraTest(DeviceTest):
   
    def get_parser(self):
        if self.argparser is None:
            argparser=super().get_parser("mender_tegra_tests.py","Tests mender functionality on tegra devices")
  
            argparser.add_argument('-i',
                                   '--install',
                                   help='The mender install argument to use with standalone install' +
                                        ' (http://mylocalserver:8000/path/to/mender/file')
        return self.argparser

    def mender_install(self):
        args = self.get_args()
        conn = self.get_connection()
        if args.install is None:
            self.get_parser().print_help()
            print("Missing argument install")
            raise RuntimeError("Missing argument install")
        result = conn.run("mender -install {}".format(args.install))
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
        result = conn.run("nvbootctrl get-current-slot")
        return result.stdout.strip()

    def check_partition_mismatch(self):
        conn = self.get_connection()
        boot_slot = self.nvbootctrl_current_slot()
        rootfs_part = None
        if boot_slot == '0':
            rootfs_part = 'A'
        elif boot_slot == '1':
            rootfs_part = 'B'

        if rootfs_part != None:
            result = conn.run(f'grep -h {rootfs_part} /etc/mender/mender.conf /var/lib/mender/mender.conf | cut -d: -f2 | cut -d, -f1 | tr -d \'" \'')
            result = conn.run(f'df -h | grep {result.stdout.strip()}')
            if result.return_code != 0:
                raise RuntimeError("Boot and Rootfs Partition Mismatch detected")
        else:
            raise RuntimeError("Cannot Identify Rootfs Partition Slot")


    def do_mender_update(self):
        # Connecting to the device
        self.wait_for_device()
        # mender install 
        self.mender_install()
       # Check Partition Mismatch
    #    self.check_partition_mismatch()
        # Get current boot slot after mender update and before reboot
        prev_boot_slot = self.nvbootctrl_current_slot()
        # reboot the device
        self.reboot()
        # Getting current_boot_slot after reboot
        current_boot_slot = self.nvbootctrl_current_slot()
        # Check if update was successful after reboot
        if prev_boot_slot == current_boot_slot:
            raise RuntimeError("Mender Install successful but slot change not reflected after reboot")
        return current_boot_slot

    def check_rollback(self):
        print("****************************************")
        print("Starting test case")
        boot_slot = self.do_single_mender_update()
        for i in range(7):
            # Check Partition Mismatch
            self.check_partition_mismatch()
            # check the current boot_slot
            if boot_slot != self.nvbootctrl_current_slot():
                raise RuntimeError("Mender Rollback occurred earlier than expected")
            self.reboot()
        # Device expected to rollback here
        if boot_slot != self.nvbootctrl_current_slot():
            print("Success: Rollback after 7 reboots")
        else:
            raise RuntimeError("ERROR: No rollback after 7 reboots")

    def do_mender_torture(self):
        """
        Do 10 mender updates in a row followed by 20 reboots, then repeat the
        entire loop 10 times
        """
        boot_slot = None
        for bigloop in range (10):
            for i in range (10):
                print("Starting mender update {}".format(10*bigloop+i+1))
                boot_slot = self.do_mender_update()
            for i in range (20):
                print("Starting reboot {}".format(20*bigloop+i+1))
                prev_boot_slot = self.nvbootctrl_current_slot()
                self.reboot()
                boot_slot = self.nvbootctrl_current_slot()
                if boot_slot != prev_boot_slot:
                    raise RuntimeError("Boot slot changed from {} to {} after {} reboots on iteration {}".format(prev_boot_slot,boot_slot,i,bigloop))
          
    def do_reboot_torture(self):
        """
        Do 200 reboots, making sure boot slot doesn't change
        """
        boot_slot = None
        for i in range (100):
            print("Starting reboot {}".format(i))
            prev_boot_slot = self.nvbootctrl_current_slot()
            self.reboot()
            boot_slot = self.nvbootctrl_current_slot()
            if boot_slot != prev_boot_slot:
                raise RuntimeError("Boot slot changed from {} to {} after {} reboots".format(prev_boot_slot,boot_slot,i))

if __name__ == '__main__':
    test = MenderTegraTest()
    test.do_mender_torture()
