# This class implements a Mender-enabled Toradex Easy Installer image
# Based largely on meta-toradex-bsp-common/classes/image_type_tezi.bbclass

# Make sure the full Mender multi-partition image is available
IMAGE_TYPEDEP:mender_tezi:append = "${@bb.utils.contains('IMAGE_FSTYPES', 'sdimg', ' sdimg.gz', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'ubimg', ' ubimg.gz', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'gptimg', ' gptimg.gz', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'uefiimg', ' uefiimg.gz', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'biosimg', ' biosimg.gz', '', d)}"

# Figure out what type of image we are basing this on
FULL_IMAGE_SUFFIX = ""
FULL_IMAGE_SUFFIX:mender-image-sd = "sdimg"
FULL_IMAGE_SUFFIX:mender-image-ubi = "ubimg"
FULL_IMAGE_SUFFIX:mender-image-uefi = "uefiimg"
FULL_IMAGE_SUFFIX:mender-image-bios = "biosimg"
FULL_IMAGE_SUFFIX:mender-image-gpt = "gptimg"

TEZI_AUTO_INSTALL ??= "false"
TEZI_CONFIG_FORMAT ??= "2"
TEZI_STORAGE_DEVICE ??= "${@os.path.basename(d.getVar('MENDER_STORAGE_DEVICE'))}"

# Do not include these image types:
IMAGE_FSTYPES:remove = "${SOC_DEFAULT_IMAGE_FSTYPES} tar.xz ${FULL_IMAGE_SUFFIX}.bz2"

WKS_FILE_DEPENDS:append = " mender-tezi-metadata "

do_image_mender_tezi[recrdeptask] += "do_deploy"
RM_WORK_EXCLUDE += "${PN}"

def rootfs_mender_tezi_emmc(d):
    from collections import OrderedDict
    offset_bootrom = d.getVar('OFFSET_BOOTROM_PAYLOAD')
    offset_spl = d.getVar('OFFSET_SPL_PAYLOAD')
    imagename = d.getVar('IMAGE_LINK_NAME')
    image_suffix = d.getVar('FULL_IMAGE_SUFFIX')
    storage_device = d.getVar('TEZI_STORAGE_DEVICE')

    bootpart_rawfiles = []

    if offset_spl:
        bootpart_rawfiles.append(
              {
                "filename": d.getVar('SPL_BINARY'),
                "dd_options": "seek=" + offset_bootrom
              })
    bootpart_rawfiles.append(
              {
                "filename": d.getVar('UBOOT_BINARY_TEZI_EMMC'),
                "dd_options": "seek=" + (offset_spl if offset_spl else offset_bootrom)
              })

    return [
        OrderedDict({
          "name": storage_device,
          "table_type": "gpt",
              "content": {
                  "rawfiles": [
                      {
                          "dd_options": "bs=8M",
                          "filename": "%s.%s.gz" % (imagename, image_suffix)
                      }
                  ]
              }
        }),
        OrderedDict({
          "name": "%sboot0" % (storage_device),
          "erase": True,
          "content": {
            "filesystem_type": "raw",
            "rawfiles": bootpart_rawfiles
          }
        })]

def rootfs_mender_tezi_rawnand(d):
    from collections import OrderedDict

    return [
        OrderedDict({
          "name": "u-boot1",
          "content": {
            "rawfile": {
              "filename": d.getVar("UBOOT_BINARY"),
              "size": 1
            }
          }
        }),
        OrderedDict({
          "name": "u-boot2",
          "content": {
            "rawfile": {
              "filename": d.getVar("UBOOT_BINARY"),
              "size": 1
            }
          }
        }),
        OrderedDict({
          "name": "u-boot-env",
          "content": {
            "rawfile": {
              "filename": "uboot.env",
              "size": 1
            }
          }
        }),
        OrderedDict({
          "name": "ubi",
          "content": {
            "rawfile": {
              "dd_options": "bs=8M",
              "filename": "%s.%s.gz" % (d.getVar("IMAGE_LINK_NAME"), d.getVar("FULL_IMAGE_SUFFIX"))
            }
          }
        })
    ]

python rootfs_mender_tezi_json() {
    json_file = "image-%s.json" % d.getVar('IMAGE_BASENAME')

    import json
    from collections import OrderedDict
    from datetime import datetime

    data = OrderedDict({ "config_format": d.getVar('TEZI_CONFIG_FORMAT'), "autoinstall": oe.types.boolean(d.getVar('TEZI_AUTO_INSTALL')) })

    data["name"] = d.getVar('SUMMARY')
    data["description"] = d.getVar('DESCRIPTION')
    data["version"] = "Mender %s" % d.getVar('DISTRO_CODENAME')
    data["release_date"] = datetime.strptime(d.getVar('SRCDATE'), '%Y%m%d').date().isoformat()
    data["prepare_script"] = "prepare.sh"
    data["wrapup_script"] = "wrapup.sh"
    data["marketing"] = "mender-tezi-metadata/marketing_mender_toradex.tar"
    data["icon"] = "mender-tezi-metadata/mender_toradex_linux.png"

    product_ids = d.getVar('TORADEX_PRODUCT_IDS')
    if product_ids is None:
        bb.fatal("Supported Toradex product ids missing, assign TORADEX_PRODUCT_IDS with a list of product ids.")
    data["supported_product_ids"] = product_ids.split()

    if (d.getVar("FULL_IMAGE_SUFFIX") == "ubimg"):
        data["mtddevs"] = rootfs_mender_tezi_rawnand(d)
    else:
        data["blockdevs"] = rootfs_mender_tezi_emmc(d)

    with open(os.path.join(d.getVar('IMGDEPLOYDIR'), json_file), 'w') as outfile:
        json.dump(data, outfile, indent=4)
}

IMAGE_CMD:mender_tezi () {
    cp ${IMGDEPLOYDIR}/image-${IMAGE_BASENAME}*.json ${WORKDIR}/image-json/image.json

    uboot_files=""
    for file in ${UBOOT_BINARY_TEZI_EMMC} ${SPL_BINARY} uboot.env; do
        if [ -f "${DEPLOY_DIR_IMAGE}/$file" ]; then
            uboot_files="${DEPLOY_DIR_IMAGE}/$file $uboot_files"
        fi
    done

    # The first transform strips all folders from the files
    # The second adds back a subfolder
    ${IMAGE_CMD_TAR} --transform='s/.*\///' \
		     --transform 's,^,${IMAGE_LINK_NAME}/,' \
		     -chf ${IMGDEPLOYDIR}/${IMAGE_NAME}.mender_tezi.tar \
		     ${WORKDIR}/image-json/image.json ${DEPLOY_DIR_IMAGE}/mender-tezi-metadata/* \
		     $uboot_files \
		     ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${FULL_IMAGE_SUFFIX}.gz
    ln -sf ${IMAGE_NAME}.mender_tezi.tar ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.mender_tezi.tar
}
do_image_mender_tezi[dirs] += "${WORKDIR}/image-json ${DEPLOY_DIR_IMAGE}"
do_image_mender_tezi[cleandirs] += "${WORKDIR}/image-json"
do_image_mender_tezi[prefuncs] += "rootfs_mender_tezi_json"
IMAGE_TYPEDEP:mender_tezi[vardepsexclude] = "SRCDATE"
