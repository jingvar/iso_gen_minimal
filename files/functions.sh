#!/bin/bash
#functions
function _build_base_os(){
export CHROOT="${HOME}/LIVE_BOOT/chroot"
  debootstrap \
    --arch=amd64 \
    --variant=minbase \
    --foreign \
    focal \
    "${HOME}"/LIVE_BOOT/chroot \
    http://archive.ubuntu.com/ubuntu/
  chroot "${CHROOT}" /debootstrap/debootstrap --second-stage
}

function _make_kernel(){
  mkdir -p "${HOME}"/LIVE_BOOT/{scratch,image/live}
  mksquashfs \
    "${HOME}"/LIVE_BOOT/chroot \
    "${HOME}"/LIVE_BOOT/image/live/filesystem.squashfs \
    -e boot

  cp "${HOME}"/LIVE_BOOT/chroot/boot/vmlinuz-* \
     "${HOME}"/LIVE_BOOT/image/vmlinuz &&
  cp "${HOME}"/LIVE_BOOT/chroot/boot/initrd.img-* \
     "${HOME}"/LIVE_BOOT/image/initrd
}

function _grub_install (){
  cp /builder/grub.conf "${HOME}"/LIVE_BOOT/scratch/grub.cfg

  touch "${HOME}/LIVE_BOOT/image/UBUNTU_FOCAL_CUSTOM"

  grub-mkstandalone \
    --format=i386-pc \
    --output="${HOME}/LIVE_BOOT/scratch/core.img" \
    --install-modules="linux normal iso9660 biosdisk memdisk search tar ls all_video" \
    --modules="linux normal iso9660 biosdisk search" \
    --locales="" \
    --fonts="" \
    boot/grub/grub.cfg="${HOME}/LIVE_BOOT/scratch/grub.cfg"

  cat \
      /usr/lib/grub/i386-pc/cdboot.img "${HOME}/LIVE_BOOT/scratch/core.img" \
      > "${HOME}/LIVE_BOOT/scratch/bios.img"
}

function _make_iso(){
  xorriso \
    -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "config-2" \
    --grub2-boot-info \
    --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
    -eltorito-boot \
        boot/grub/bios.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --eltorito-catalog boot/grub/boot.cat \
    -output "/config/ephemeral.iso" \
    -graft-points \
        "${HOME}/LIVE_BOOT/image" \
        /boot/grub/bios.img="${HOME}/LIVE_BOOT/scratch/bios.img"
  chmod 666 /config/ephemeral.iso  
}

function _cloud_init_data(){
  export CLOUD_DATA=${CHROOT}/var/lib/cloud/seed/nocloud
  mkdir -p $CLOUD_DATA
  cp "/config/meta-data"      "${CLOUD_DATA}/"
  cp "/config/user-data"      "${CLOUD_DATA}/"
  cp "/config/network-config" "${CLOUD_DATA}/"
  # Set cloud-init DataSource
  echo "datasource_list: [ NoCloud, None ]" > \
      "${CHROOT}/etc/cloud/cloud.cfg.d/95_no_cloud_ds.cfg"
}

function _packages_install(){
  chroot "${CHROOT}" < "${BASEDIR}/packages_install.sh"
}
