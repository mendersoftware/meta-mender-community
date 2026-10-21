#!/usr/bin/env python3
"""Host tests of extracted BitBake functions and rendered state scripts.

Mounts, device-node checks and free-space queries are simulated. File staging,
copying and renaming use real temporary files; no FAT or boot test is implied.
"""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import types
import unittest

LAYER = Path(__file__).resolve().parents[1]
CLASS = LAYER / 'classes/rpi-update-firmware.bbclass'
SCRIPT = LAYER / 'recipes-mender/update-firmware-state-script/files/ArtifactInstall_Leave_50.in'


def fatal(message):
    raise ValueError(message)


def load_functions():
    text = CLASS.read_text()
    start = text.index('def rpi_firmware_files(')
    end = text.index('\npython rpi_install_firmware_to_rootfs')
    stage = text[end:].split('{\n', 1)[1].split('\n}', 1)[0]
    namespace = {'bb': types.SimpleNamespace(fatal=fatal)}
    exec(text[start:end] + '\ndef stage(d):\n' + stage, namespace)
    return namespace


class StagingTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.deploy = self.root / 'deploy'
        self.rootfs = self.root / 'rootfs'
        self.out = self.rootfs / 'boot/firmware'
        files = {'plain.bin': 'plain', 'nested/one.bin': 'one', 'nested/two.bin': 'two',
                 'real.dtb': 'dtb', 'overlay_map.dtb': 'map', 'other.bin': 'other',
                 'same.bin': 'plain', 'bootfiles/config.txt': 'config',
                 'bootfiles/custom.txt': 'custom'}
        for name, content in files.items():
            p = self.deploy / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(content)
        (self.deploy / 'alias.dtb').symlink_to('real.dtb')
        (self.rootfs / 'boot').mkdir(parents=True)
        (self.rootfs / 'boot/Image-1').write_text('kernel')
        (self.rootfs / 'boot/Image').symlink_to('Image-1')
        self.fn = load_functions()

    def stage(self, mapping, exclude=''):
        values = {'DEPLOY_DIR_IMAGE': str(self.deploy), 'IMAGE_ROOTFS': str(self.rootfs),
                  'IMAGE_BOOT_FILES': mapping, 'RPI_FIRMWARE_EXCLUDE': exclude}
        self.fn['stage'](types.SimpleNamespace(getVar=values.get))
        return {str(p.relative_to(self.out)): p.read_text() for p in self.out.rglob('*') if p.is_file()}

    def test_mapping_semantics(self):
        cases = [
            ('plain.bin', {'plain.bin': 'plain'}),
            ('nested/one.bin', {'one.bin': 'one'}),
            ('nested/one.bin;custom/renamed.bin', {'custom/renamed.bin': 'one'}),
            ('plain.bin;custom/', {'custom/plain.bin': 'plain'}),
            ('nested/one.bin;./', {'one.bin': 'one'}),
            ('nested/one.bin;.', None),
            ('nested/*.bin;custom/', {'custom/one.bin': 'one', 'custom/two.bin': 'two'}),
            ('nested/*.bin;custom', None),
            ('nested/*.bin', {'one.bin': 'one', 'two.bin': 'two'}),
            ('overlay_map.dtb;overlays/overlay_map.dtb', {'overlays/overlay_map.dtb': 'map'}),
            ('alias.dtb', {'alias.dtb': 'dtb'}),
            ('real.dtb alias.dtb', {'real.dtb': 'dtb', 'alias.dtb': 'dtb'}),
            ('missing.bin', None), ('absent/*.dtbo;overlays/', None),
            ('plain.bin absent/*.dtbo;overlays/', None),
            ('plain.bin;target.bin other.bin;target.bin', None),
            ('plain.bin;target.bin same.bin;target.bin', {'target.bin': 'plain'}),
            ('bootfiles/*', {'config.txt': 'config', 'custom.txt': 'custom'}),
            ('', None),
        ]
        for mapping, expected in cases:
            with self.subTest(mapping=mapping):
                if expected is None:
                    with self.assertRaises(ValueError):
                        self.stage(mapping)
                else:
                    self.assertEqual(self.stage(mapping), expected)
                    self.assertFalse(any(p.is_symlink() for p in self.out.rglob('*')))

    def test_exclusion_and_kernel_preservation(self):
        self.assertEqual(self.stage('bootfiles/*', 'custom.txt'), {'config.txt': 'config'})
        self.assertTrue((self.deploy / 'bootfiles/custom.txt').is_file())
        self.assertEqual((self.rootfs / 'boot/Image').read_text(), 'kernel')
        self.assertTrue((self.rootfs / 'boot/Image').is_symlink())

    def test_preflight_does_not_change_previous_staging(self):
        old = self.stage('plain.bin')
        for value in ('plain.bin missing', 'plain.bin;../escape', '/etc/passwd',
                      'plain.bin;/absolute', 'nested', 'plain.bin;bad;more',
                      'plain.bin;bad$name', 'plain.bin;custom/.'):
            with self.subTest(value=value), self.assertRaises(ValueError):
                self.stage(value)
            self.assertEqual({p.name: p.read_text() for p in self.out.iterdir()}, old)

    def test_symlink_outside_deploy_is_rejected(self):
        (self.root / 'outside').write_text('outside')
        (self.deploy / 'escape').symlink_to('../outside')
        with self.assertRaises(ValueError):
            self.stage('escape')

    def test_repeated_staging_removes_unselected_staged_files(self):
        self.stage('plain.bin other.bin')
        self.assertEqual(self.stage('plain.bin'), {'plain.bin': 'plain'})


COMMAND = r'''#!/usr/bin/env python3
import json, os, shutil, sys
from pathlib import Path
name = Path(sys.argv[0]).name
args = sys.argv[1:]
r = Path(os.environ['FIXTURE'])
with (r / 'commands.jsonl').open('a') as log:
    log.write(json.dumps([name, args]) + '\n')
if name == 'find':
    if any(arg.startswith('-') and arg not in ('-type', '-print') for arg in args):
        sys.exit('Unsupported find option in portable traversal')
    os.execv(shutil.which('find', path='/usr/bin:/bin') or sys.exit('find not found'), ['find', *args])
elif name == 'findmnt':
    if '-S' in args:
        sys.exit(0 if os.environ.get('ALREADY_MOUNTED') else 1)
    target = args[-1]
    field = args[args.index('-o') + 1]
    if field == 'OPTIONS':
        print(os.environ.get('BOOT_OPTIONS', 'rw') if target == str(r / 'boot') else os.environ.get('SOURCE_OPTIONS', 'ro'))
    else:
        print(r / (os.environ.get('ACTIVE', 'a') if target == '/' else os.environ.get('BOOT_DEVICE', 'boot-device') if target == str(r / 'boot') else os.environ.get('SOURCE_DEVICE', 'a' if os.environ.get('ACTIVE') == 'b' else 'b')))
elif name == 'mount':
    if os.environ.get('FAIL_MOUNT'):
        sys.exit(1)
    shutil.copytree(r / 'payload', args[-1], dirs_exist_ok=True, symlinks=True)
elif name == 'umount':
    sys.exit(1 if os.environ.get('FAIL_UMOUNT') else 0)
elif name == 'stat':
    if '-f' in args:
        if args[args.index('-c') + 1] == '%S':
            print('4096')
        else:
            used = sum((p.stat().st_size + 4095) // 4096 for p in (r / 'boot').rglob('*') if p.is_file())
            print(int(os.environ.get('FREE_BLOCKS', '100000')) - (used if os.environ.get('DYNAMIC_SPACE') else 0))
    else:
        print(Path(args[-1]).stat().st_size)
elif name == 'cp':
    if os.environ.get('FAIL_COPY') == Path(args[0]).name:
        sys.exit(1)
    shutil.copyfile(*args)
elif name == 'sync':
    if os.environ.get('FAIL_SYNC') or (os.environ.get('FAIL_DIRECTORY_SYNC') and Path(args[-1]).is_dir()):
        sys.exit(1)
'''


class ScriptTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.payload = self.root / 'payload/boot/firmware'
        self.payload.mkdir(parents=True)
        self.boot = self.root / 'boot'
        self.boot.mkdir()
        self.write_payload({'config.txt': 'new', 'cmdline.txt': 'new-cmd', 'boot.scr': 'script',
                            'kernel_2712.img': 'uboot', 'overlays/overlay_map.dtb': 'map'})
        (self.boot / 'config.txt').write_text('old')
        (self.boot / 'user.dtbo').write_text('user')
        (self.root / 'payload/boot/Image-version').write_text('kernel')
        for part in ('a', 'b', 'boot-device'):
            (self.root / part).touch()
        commands = self.root / 'bin'
        commands.mkdir()
        for name in ('find', 'findmnt', 'mount', 'umount', 'stat', 'cp', 'sync'):
            p = commands / name
            p.write_text(COMMAND)
            p.chmod(0o755)
        self.env = {**os.environ, 'PATH': str(commands) + ':' + os.environ['PATH'], 'FIXTURE': str(self.root)}
        text = SCRIPT.read_text()
        for key, value in {'MENDER_ROOTFS_PART_A': str(self.root / 'a'),
                           'MENDER_ROOTFS_PART_B': str(self.root / 'b'),
                           'MENDER_BOOT_PART': str(self.root / 'boot-device'),
                           'MENDER_BOOT_PART_MOUNT_LOCATION': str(self.boot),
                           'RPI_FIRMWARE_REQUIRED_FILES': 'config.txt cmdline.txt boot.scr kernel_2712.img',
                           'RPI_FIRMWARE_SPACE_RESERVE_KIB': '1024'}.items():
            text = text.replace('@@' + key + '@@', value)
        # Explicit test seams for device-node checks and the temporary directory.
        text = text.replace('[ -b ', '[ -f ')
        text = text.replace('/tmp/mender-firmware.', str(self.root / 'mender-firmware.'))
        self.script = self.root / 'script'
        self.script.write_text(text)

    def write_payload(self, files):
        for name, value in files.items():
            p = self.payload / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(value)

    def run_script(self, **env):
        return subprocess.run(['/bin/sh', str(self.script)], env={**self.env, **env}, capture_output=True, text=True, timeout=30)

    def calls(self, name):
        return [args for command, args in map(json.loads, (self.root / 'commands.jsonl').read_text().splitlines()) if command == name]

    def test_success_and_repeat_preserve_unselected(self):
        for _ in range(2):
            result = self.run_script()
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((self.boot / 'config.txt').read_text(), 'new')
            self.assertEqual((self.boot / 'overlays/overlay_map.dtb').read_text(), 'map')
            self.assertEqual((self.boot / 'user.dtbo').read_text(), 'user')
            self.assertFalse((self.boot / 'Image-version').exists())
            self.assertFalse(list(self.root.glob('mender-firmware.*')))
        copied = [Path(args[0]).name for args in self.calls('cp')]
        self.assertEqual(copied[-2:], ['cmdline.txt', 'config.txt'])
        self.assertEqual(len(copied), 5)
        self.assertEqual(len(self.calls('umount')), 2)

    def test_boot_mount_path_is_normalized(self):
        template = self.script.read_text()
        for suffix in ('/', '//', '/.', '/../boot/'):
            with self.subTest(suffix=suffix):
                self.script.write_text(template.replace('boot="' + str(self.boot) + '"',
                                                        'boot="' + str(self.boot) + suffix + '"'))
                (self.boot / 'config.txt').write_text('old')
                result = self.run_script()
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual((self.boot / 'config.txt').read_text(), 'new')
                self.assertEqual(self.calls('sync')[-1], ['-f', str(self.boot)])

    def test_missing_required_preflight(self):
        (self.payload / 'boot.scr').unlink()
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('missing required', result.stderr)
        self.assertFalse(self.calls('cp'))
        self.assertEqual((self.boot / 'config.txt').read_text(), 'old')
        self.assertEqual(len(self.calls('umount')), 1)

    def test_decimal_reserve_accepted(self):
        template = self.script.read_text()
        for reserve in ('0', '100', '1024'):
            with self.subTest(reserve=reserve):
                self.script.write_text(template.replace('reserve_kib="1024"', 'reserve_kib="' + reserve + '"'))
                (self.boot / 'config.txt').write_text('old')
                result = self.run_script()
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual((self.boot / 'config.txt').read_text(), 'new')
                self.assertEqual((self.boot / 'user.dtbo').read_text(), 'user')
                self.assertEqual(Path(self.calls('cp')[-1][0]).name, 'config.txt')
                self.assertFalse(list(self.root.glob('mender-firmware.*')))

    def test_capacity_preflight(self):
        result = self.run_script(FREE_BLOCKS='0')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('insufficient boot space', result.stderr)
        self.assertFalse(self.calls('cp'))
        self.assertEqual((self.boot / 'config.txt').read_text(), 'old')

    def check_failure_and_retry(self, failure, renamed):
        result = self.run_script(**failure)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.boot / 'boot.scr').exists(), renamed)
        self.assertEqual((self.boot / 'config.txt').read_text(), 'old')
        self.assertFalse(list(self.boot.rglob('.mender-firmware.*')))
        self.assertFalse(list(self.root.glob('mender-firmware.*')))
        self.assertEqual(len(self.calls('umount')), 1)
        if 'FAIL_DIRECTORY_SYNC' in failure:
            self.assertEqual(self.calls('sync')[-1], [str(self.boot)])
        self.assertEqual(self.run_script().returncode, 0)

    def test_copy_failure_cleanup_and_retry(self):
        self.check_failure_and_retry({'FAIL_COPY': 'kernel_2712.img'}, renamed=True)

    def test_file_sync_failure_cleanup_and_retry(self):
        self.check_failure_and_retry({'FAIL_SYNC': '1'}, renamed=False)

    def test_directory_sync_failure_cleanup_and_retry(self):
        self.check_failure_and_retry({'FAIL_DIRECTORY_SYNC': '1'}, renamed=True)

    def test_partial_update_capacity_allows_retry(self):
        self.write_payload({'a-large.bin': 'x' * (8 * 1024 * 1024), 'z-large.bin': 'z' * (2 * 1024 * 1024)})
        env = {'FREE_BLOCKS': '3072', 'DYNAMIC_SPACE': '1'}
        result = self.run_script(**env, FAIL_COPY='z-large.bin')
        self.assertNotEqual(result.returncode, 0)
        self.assertTrue((self.boot / 'a-large.bin').is_file())
        self.assertEqual((self.boot / 'config.txt').read_text(), 'old')
        result = self.run_script(**env)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.boot / 'config.txt').read_text(), 'new')

    def test_partition_b_active(self):
        result = self.run_script(ACTIVE='b')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls('mount')[0][-2], str(self.root / 'a'))

    def test_invalid_mounts_fail_before_copy(self):
        for env in ({'ACTIVE': 'boot-device'}, {'BOOT_DEVICE': 'a'}, {'BOOT_OPTIONS': 'ro'}):
            with self.subTest(env=env):
                self.assertNotEqual(self.run_script(**env).returncode, 0)
                self.assertFalse(self.calls('cp'))

    def test_mount_failure(self):
        self.assertNotEqual(self.run_script(FAIL_MOUNT='1').returncode, 0)
        self.assertFalse(self.calls('cp'))
        self.assertFalse(self.calls('umount'))

    def test_already_mounted_source_rejected(self):
        self.assertNotEqual(self.run_script(ALREADY_MOUNTED='1').returncode, 0)
        self.assertFalse(self.calls('mount'))

    def test_unmount_failure_keeps_mount_directory(self):
        self.assertNotEqual(self.run_script(FAIL_UMOUNT='1').returncode, 0)
        self.assertTrue(list(self.root.glob('mender-firmware.*')))


if __name__ == '__main__':
    unittest.main(verbosity=2)
