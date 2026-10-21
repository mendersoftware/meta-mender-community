RPI_FIRMWARE_EXCLUDE ?= ""

def rpi_firmware_files(d):
    import filecmp
    import glob
    import os
    import re

    deploy = os.path.realpath(d.getVar('DEPLOY_DIR_IMAGE'))
    selected = {}
    excluded = set((d.getVar('RPI_FIRMWARE_EXCLUDE') or '').split())

    def valid_path(value, pattern=False):
        chars = r'[A-Za-z0-9_.+/*?\[\]!-]+' if pattern else r'[A-Za-z0-9_.+/-]+'
        if (not re.fullmatch(chars, value) or value.startswith('/')
                or value.endswith('/.') or '..' in value.split('/') or value.rstrip('/') in ('', '.')):
            bb.fatal('Unsupported firmware path: %s' % value)

    for entry in (d.getVar('IMAGE_BOOT_FILES') or '').split():
        parts = entry.split(';')
        if len(parts) > 2 or not all(parts):
            bb.fatal('Malformed IMAGE_BOOT_FILES entry: %s' % entry)
        source = parts[0]
        valid_path(source, pattern=True)
        destination = parts[1] if len(parts) == 2 else None
        if destination == './':
            destination = None
        if destination is not None:
            valid_path(destination)
        matches = sorted(glob.glob(os.path.join(deploy, source)))
        if not matches:
            bb.fatal('IMAGE_BOOT_FILES entry has no input: %s' % entry)
        for path in matches:
            real = os.path.realpath(path)
            if os.path.commonpath([deploy, real]) != deploy or not os.path.isfile(real):
                bb.fatal('Firmware input is not a file within deploy: %s' % path)
            if destination is None:
                target = os.path.basename(path)
            elif destination.endswith('/'):
                target = destination + os.path.basename(path)
            else:
                target = destination
            valid_path(target)
            target = os.path.normpath(target)
            if target in selected and not filecmp.cmp(selected[target], real, shallow=False):
                bb.fatal('Conflicting firmware contents at: %s' % target)
            selected[target] = real

    return [(source, target) for target, source in sorted(selected.items()) if target not in excluded]

python rpi_install_firmware_to_rootfs() {
    import os
    import shutil

    files = rpi_firmware_files(d)
    if not files:
        bb.fatal('No firmware files selected for updating')
    rootfs = os.path.realpath(d.getVar('IMAGE_ROOTFS'))
    destination = os.path.join(rootfs, 'boot', 'firmware')
    if os.path.exists(destination):
        shutil.rmtree(destination)
    os.makedirs(destination)
    for source, target in files:
        path = os.path.join(destination, target)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        shutil.copyfile(source, path)
        os.chmod(path, 0o644)
}
ROOTFS_POSTPROCESS_COMMAND += "rpi_install_firmware_to_rootfs"

do_rootfs[depends] += " \
    virtual/kernel:do_deploy \
    rpi-bootfiles:do_deploy \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot:do_deploy u-boot-default-script:do_deploy', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'armstub', 'armstubs:do_deploy', '', d)} \
"

do_image_mender[depends] += "update-firmware-state-script:do_deploy"

IMAGE_INSTALL:append = " update-firmware-state-script"
