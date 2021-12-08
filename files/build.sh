set -xe
BASEDIR="$(dirname "$(realpath "$0")")"
source "${BASEDIR}/functions.sh"

_build_base_os
_packages_install
_cloud_init_data
_make_kernel
_grub_install
_make_iso
