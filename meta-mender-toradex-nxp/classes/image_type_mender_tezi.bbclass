# This class implements a Mender-enabled Toradex Easy Installer image
# Based largely on meta-toradex-bsp-common/classes/image_type_tezi.bbclass

# Make sure the full Mender multi-partition image is available
IMAGE_TYPEDEP_mender_tezi_append = "${@bb.utils.contains('IMAGE_FSTYPES', 'sdimg', ' sdimg.bz2', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'gptimg', ' gptimg.bz2', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'uefiimg', ' uefiimg.bz2', '', d)} \
                                       ${@bb.utils.contains('IMAGE_FSTYPES', 'biosimg', ' biosimg.bz2', '', d)}"

# Figure out what type of image we are basing this on
FULL_IMAGE_SUFFIX = ""
FULL_IMAGE_SUFFIX_mender-image-sd = "sdimg"
FULL_IMAGE_SUFFIX_mender-image-ubi = "ubimg"
FULL_IMAGE_SUFFIX_mender-image-uefi = "uefiimg"
FULL_IMAGE_SUFFIX_mender-image-bios = "biosimg"
FULL_IMAGE_SUFFIX_mender-image-gpt= "gptimg"
python () {
   if d.getVar('FULL_IMAGE_SUFFIX') == "":
       bb.fatal("Unable to determine FULL_IMAGE_SUFFIX for use with mender_tezi images.")
}

# Do not include these image types:
IMAGE_FSTYPES_remove = "${SOC_DEFAULT_IMAGE_FSTYPES} tar.xz"

WKS_FILE_DEPENDS_append = " mender-tezi-metadata "

do_image_mender_tezi[recrdeptask] += "do_deploy"
RM_WORK_EXCLUDE += "${PN}"

python() {
  if d.getVar("MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET") != d.getVar("OFFSET_BOOTROM_PAYLOAD"):
      bb.fatal("Error.  MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET (%s) != OFFSET_BOOTROM_PAYLOAD (%s)" % \
                  (d.getVar("MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET"), d.getVar("OFFSET_BOOTROM_PAYLOAD")))
}

def rootfs_mender_tezi_emmc(d):
    from collections import OrderedDict

    return [
        OrderedDict({
          "name": "mmcblk0",
          "table_type": "gpt",
              "content": {
                  "rawfiles": [
                      {
                          "filename": "%s.%s.bz2" % (d.getVar("IMAGE_LINK_NAME"), d.getVar("FULL_IMAGE_SUFFIX"))
                      }
                  ]
              }
        }),
        OrderedDict({
          "name": "mmcblk0boot0",
          "content": {
            "rawfiles": [
              {
                "dd_options": "seek=" + d.getVar('OFFSET_BOOTROM_PAYLOAD'),
                "filename": d.getVar("SPL_BINARY")
              },
              {
                "filename": d.getVar('UBOOT_BINARY'),
                "dd_options": "seek=" + d.getVar('OFFSET_SPL_PAYLOAD')
              }
            ]
          }
        })
    ]

def rootfs_mender_tezi_rawnand(d):
    # TBD
    return []

python rootfs_mender_tezi_json() {
    flash_data = rootfs_mender_tezi_emmc(d)
    json_file = "image-%s.json" % d.getVar('IMAGE_BASENAME')

    import json
    from collections import OrderedDict
    from datetime import datetime

    data = OrderedDict({ "config_format": 2, "autoinstall": False })

    data["name"] = d.getVar('SUMMARY')
    data["description"] = d.getVar('DESCRIPTION')
    data["version"] = "Mender %s" % d.getVar('DISTRO_CODENAME')
    data["release_date"] = datetime.strptime(d.getVar('SRCDATE'), '%Y%m%d').date().isoformat()
    data["prepare_script"] = "prepare.sh"
    data["wrapup_script"] = "wrapup.sh"
    data["marketing"] = "marketing_mender_toradex.tar"
    data["icon"] = "mender_toradex_linux.png"

    product_ids = d.getVar('TORADEX_PRODUCT_IDS')
    if product_ids is None:
        bb.fatal("Supported Toradex product ids missing, assign TORADEX_PRODUCT_IDS with a list of product ids.")
    data["supported_product_ids"] = product_ids.split()

    data["blockdevs"] = flash_data

    with open(os.path.join(d.getVar('IMGDEPLOYDIR'), json_file), 'w') as outfile:
        json.dump(data, outfile, indent=4)
}

IMAGE_CMD_mender_tezi () {
    cp ${IMGDEPLOYDIR}/image-${IMAGE_BASENAME}*.json ${WORKDIR}/image-json/image.json

    # The first transform strips all folders from the files to tar
    ${IMAGE_CMD_TAR} --transform='s/.*\///' \
		     -chf ${IMGDEPLOYDIR}/${IMAGE_NAME}.mender_tezi.tar \
		     ${WORKDIR}/image-json/image.json ${DEPLOY_DIR_IMAGE}/mender-tezi-metadata/* \
		     ${DEPLOY_DIR_IMAGE}/${SPL_BINARY} \
		     ${DEPLOY_DIR_IMAGE}/${UBOOT_BINARY} \
		     ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${FULL_IMAGE_SUFFIX}.bz2
    ln -s ${IMAGE_NAME}.mender_tezi.tar ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.mender_tezi.tar
}
do_image_mender_tezi[dirs] += "${WORKDIR}/image-json ${DEPLOY_DIR_IMAGE}"
do_image_mender_tezi[cleandirs] += "${WORKDIR}/image-json"
do_image_mender_tezi[prefuncs] += "rootfs_mender_tezi_json"
IMAGE_TYPEDEP_mender_tezi[vardepsexclude] = "SRCDATE"

