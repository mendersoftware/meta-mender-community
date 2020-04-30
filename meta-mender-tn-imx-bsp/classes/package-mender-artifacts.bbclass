#
# Copyright 2019-2020 TechNexion Ltd.
#
# Class to .mender artifact type, which wraps ipk/deb/rpm packages in an
# update-able .mender artifact.
#

# ------------------------------ CONFIGURATION ---------------------------------

# Extra arguments that should be passed to mender-artifact.
MENDER_ARTIFACT_EXTRA_ARGS ?= ""

# The key used to sign the mender update.
MENDER_ARTIFACT_SIGNING_KEY ?= ""

# The list of PACKAGES to be wrapped into .mender packages
MENDER_ARTIFACT_PACKAGES ?= ""

#
# --------------------------- CONCEPT EXPLANATION -----------------------------
#
# package.bbclass (poky) handles the packaging steps, i.e.
#   a) package_get_auto_pr, b) perform_packagecopy, c) package_do_split_locales
#   d) split_and_strip_files, e) fix_perms, f) populate_packages
#   g) package_do_filedeps, h) package_do_shlibs, i) package_do_pkgconfig
#   j) read_shlibdeps, k) package_depchains, l) emit_pkgdata
#
# package_deb.bbclass, package_ipk.bbclass, package_rpm.bbclass, then handle
# the wrapping up of packages in different format, i.e.
#   - do_package_write_deb,
#   - do_package_write_ipk,
#   - do_package_write_rpm,
#
# package-mender-artifacits.bbclass, takes the results of the deb, ipk, rpm and wrap
# the package into .mender artifact (which is used for mender update modules on target device)
#   - add mender_find_archived_package() to do_package_write_rpm/ipk/deb[postfuncs] callback
#     list, and the function finds where the rpm/ipk/deb package file is located with full path.
#   - add mender_wrap_artifact() after mender_find_archived_package() to use
#     mender-artifact-native binary to wrap up the rpm/ipk/deb pacakge.
#
# NOTE: We can use IMAGE_PKGTYPE to differentiate the packaging format
#       (e.g. deb, ipk, rpm). And then add the additional task/function that
#       generate .mender artifact for packages specified by $MENDER_ARTIFACT_PACKAGES
#
# (From yocto manual: IMAGE_PKGTYPE: You should not set the IMAGE_PKGTYPE manually.
#                     Rather, the variable is set indirectly through the appropriate
#                     package_* class using the PACKAGE_CLASSES variable.)
# (Alternatively: Use python bb.data.inherits_class('package_rpm/ipk/deb', d) to check
#                 the package bbclass we are inheriting.
#

python mender_find_archived_package () {
    build_number = '0' if d.getVar('MENDER_ARTIFACT_NAME') is None else '%s' % d.getVar('MENDER_ARTIFACT_NAME').split('-')[-1]
    vars = {
        "PN" : d.getVar('PN'),
        "PV" : d.getVar('PV'),
        "PR" : d.getVar('PR'),
        "ARCH" : d.getVar('PACKAGE_ARCH'),
    }
    if bb.data.inherits_class('package_rpm', d):
        pkg = '%s-%s-%s.%s' % (vars["PN"], vars["PV"], vars["PR"], vars["ARCH"])
        packagedir = '%s/%s' % (d.getVar('PKGWRITEDIRRPM'), vars["ARCH"])
        pkgtype = 'rpm'
    elif bb.data.inherits_class('package_ipk', d):
        pkg = '%s_%s-%s_%s' % (vars["PN"], vars["PV"], vars["PR"], vars["ARCH"])
        packagedir = '%s/%s' % (d.getVar('PKGWRITEDIRIPK'), vars["ARCH"])
        pkgtype = 'ipk'
    elif bb.data.inherits_class('package_deb', d):
        pkg = '%s_%s-%s_%s' % (vars["PN"], vars["PV"], vars["PR"], d.getVar('DPKG_ARCH'))
        packagedir = '%s/%s' % (d.getVar('PKGWRITEDIRDEB'), vars["ARCH"])
        pkgtype = 'deb'

    bb.note("Use %s/%s.%s for mender artifact" % (packagedir, pkg, pkgtype))
    d.setVar('MENDER_BUILD_NUMBER', '%s' % build_number)
    d.setVar('MENDER_PACKAGE_PATH', '%s/%s.%s' % (packagedir, pkg, pkgtype))
    d.setVar('MENDER_PACKAGE_ARTIFACT', '%s' % pkg)
    d.setVar('MENDER_PACKAGE_TYPE', '%s' % pkgtype)
}
mender_find_archived_package[vardepsexclude] = "BB_NUMBER_THREADS"
mender_find_archived_package[vardepsexclude] = "OVERRIDES"

mender_wrap_artifact () {
    ARTIFACT_NAME="${MENDER_PACKAGE_ARTIFACT}-${MENDER_PACKAGE_TYPE}"
    OUTPUT_PATH="${DEPLOY_DIR_IMAGE}/${ARTIFACT_NAME}-${MENDER_BUILD_NUMBER}.mender"
    if [ ! -d ${DEPLOY_DIR_IMAGE} ]; then
      mkdir -p ${DEPLOY_DIR_IMAGE}
    fi
    mender-artifact write module-image -T ${MENDER_PACKAGE_TYPE} -n ${ARTIFACT_NAME} -t ${MACHINE} -o ${OUTPUT_PATH} -f ${MENDER_PACKAGE_PATH}
    if [ -f "${MENDER_ARTIFACT_SIGNING_KEY}" ]; then
        mender-artifact sign ${OUTPUT_PATH} -k ${MENDER_ARTIFACT_SIGNING_KEY} -o ${DEPLOY_DIR_IMAGE}/${ARTIFACT_NAME}-${MENDER_BUILD_NUMBER}.signed.mender
    fi
    bbnote "Generated mender artifact: ${OUTPUT_PATH}"
}
mender_wrap_artifact[vardepsexclude] = "BB_NUMBER_THREADS"
mender_wrap_artifact[vardepsexclude] = "OVERRIDES"

python () {
    if d.getVar('MENDER_ARTIFACT_PACKAGES') is None:
        bb.warn("Please specify $MENDER_ARTIFACT_PACKAGES to generate rpm/ipk/deb package mender-artifacts...")
    else:
        artpackages = d.getVar('MENDER_ARTIFACT_PACKAGES').split()
        if d.getVar('PN') in artpackages:
            # check if current package is in $MENDER_ARTIFACT_PACKAGES
            depstr = 'mender-artifact-native:do_populate_sysroot'
            if bb.data.inherits_class('package_rpm', d) and depstr not in d.getVarFlag('do_package_write_rpm', 'depends'):
                d.appendVarFlag('do_package_write_rpm', 'depends', ' %s' % depstr)
                d.appendVarFlag('do_package_write_rpm', 'postfuncs', ' mender_find_archived_package')
                d.appendVarFlag('do_package_write_rpm', 'postfuncs', ' mender_wrap_artifact')
            elif bb.data.inherits_class('package_ipk', d) and depstr not in d.getVarFlag('do_package_write_ipk', 'depends'):
                d.appendVarFlag('do_package_write_ipk', 'depends', ' %s' % depstr)
                d.appendVarFlag('do_package_write_ipk', 'postfuncs', ' mender_find_archived_package')
                d.appendVarFlag('do_package_write_ipk', 'postfuncs', ' mender_wrap_artifact')
            elif bb.data.inherits_class('package_deb', d) and depstr not in d.getVarFlag('do_package_write_deb', 'depends'):
                d.appendVarFlag('do_package_write_deb', 'depends', ' %s' % depstr)
                d.appendVarFlag('do_package_write_deb', 'postfuncs', ' mender_find_archived_package')
                d.appendVarFlag('do_package_write_deb', 'postfuncs', ' mender_wrap_artifact')
            d.appendVarFlag('do_clean', 'postfuncs', ' mender_clean_deployed_artifact')
}

python mender_clean_deployed_artifact () {
    import os
    vars  = {
        "PN" : d.getVar('PN'),
        "PV" : d.getVar('PV'),
        "PR" : d.getVar('PR'),
        "ARCH" : d.getVar('PACKAGE_ARCH'),
    }
    if bb.data.inherits_class('package_rpm', d):
        pkgname = '%s-%s-%s.%s-rpm' % (vars["PN"], vars["PV"], vars["PR"], vars["ARCH"])
    elif bb.data.inherits_class('package_ipk', d):
        pkgname = '%s_%s-%s_%s-ipk' % (vars["PN"], vars["PV"], vars["PR"], vars["ARCH"])
    elif bb.data.inherits_class('package_deb', d):
        pkgname = '%s_%s-%s_%s-deb' % (vars["PN"], vars["PV"], vars["PR"], d.getVar('DPKG_ARCH'))
    deploy_dir = d.getVar('DEPLOY_DIR_IMAGE')
    files = [f for f in os.listdir(deploy_dir) if f.endswith(".mender") and os.path.isfile(os.path.join(deploy_dir, f))]
    for f in files:
        if pkgname is not None and pkgname in f:
            bb.note("Removing mender artifact: %s" % os.path.join(deploy_dir, f))
            os.remove(os.path.join(deploy_dir, f))
}

