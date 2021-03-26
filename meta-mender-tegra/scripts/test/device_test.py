import fabric2
from fabric2 import Connection
import argparse
import time
import traceback
import sys
import re
import subprocess
import platform

class DeviceTest:
    DEFAULT_USER = 'root'
    DEFAULT_BOOT_METHOD = 'cboot'
    args = None
    connection = None
    argparser = None
    
    def get_parser(self,parent_test="",parent_description=""):
        if self.argparser is None:
            '''
            Argument parsing for new deployment and provisioning process
            '''
            argparser = argparse.ArgumentParser(prog=parent_test,
                                                usage='%(prog)s [options]',
                                                description=parent_description,
                                                formatter_class=argparse.RawTextHelpFormatter)
            argparser.add_argument('-d',
                                   '--device',
                                   help='The IP address or name of the device')

            argparser.add_argument('-u',
                                   '--user',
                                   help=f"The SSH username (default is {self.DEFAULT_USER})")

            argparser.add_argument('-p',
                                   '--password',
                                   help='The SSH password (default is no password)')

            argparser.add_argument('-k',
                                   '--key',
                                   help='The SSH key file (used instead of password if specified)')

            self.argparser = argparser 
        return self.argparser


    def get_args(self):
        if self.args is None:
            self.args = self.get_parser().parse_args()

            if self.args.user is None:
                print(f"No user specified, using {self.DEFAULT_USER}")
                self.args.user=self.DEFAULT_USER
        return self.args

    def get_connection(self):
        args = self.get_args()
        if args.device is None:
            print("Missing device argument")
            self.get_parser().print_help()
            raise RuntimeError("Must specify device as argument")
        if self.connection is None:
            if args.key is not None:
                self.connection = Connection(
                    host=f'{args.user}@{args.device}',
                    connect_kwargs={
                        "key_filename": args.key,
                        "password": args.password
                    })
            elif args.password is not None:
                self.connection = Connection(
                    host=f'{args.user}@{args.device}',
                    connect_kwargs={
                        "password": args.password
                    })
            else:
                self.connection = Connection(
                    host=f'{args.user}@{args.device}',
                    connect_kwargs={
                        "password": "",
                        "look_for_keys": False
                    })
        return self.connection

    def wait_for_device(self):
        conn = self.get_connection()
        print(f'Trying to connect to {self.get_args().device}....')
        success = False
        ip = None
        quiet = False
        while not success:
            try:
                conn.open()
                success = True
            except Exception as e:
                if not quiet:
                    print(e)
                    print('Exception connecting, retrying..')
                    quiet = True
            time.sleep(3)
        time.sleep(15)

    def ping(self):
        args=self.get_args()
        """
        Returns True if host (str) responds to a ping request.
        Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
        See https://stackoverflow.com/a/32684938/1446624
        """

        # Option for the number of packets as a function of
        param = '-n' if platform.system().lower() == 'windows' else '-c'

        # Building the command. Ex: "ping -c 1 google.com"
        command = ['ping', param, '1', args.device]

        return subprocess.call(command, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT) == 0

    def wait_for_device_removal(self):
        while self.ping():
            pass

    def reboot(self):
        conn = self.get_connection()
        print("Rebooting device")
        result = conn.run("reboot", warn=True)
        self.wait_for_device_removal()
        self.wait_for_device()
        self.get_machine_id() # This tests the connection

    def get_machine_id(self):
        conn = self.get_connection()
        result = conn.run("systemd-machine-id-setup --print", hide=True, timeout=3)
        return result.stdout
