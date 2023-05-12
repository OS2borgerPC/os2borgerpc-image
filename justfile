_umount-old-image MOUNTPOINT:
  sudo umount {{MOUNTPOINT}}

build_os2borgerpc_image INPUT_ISO OUTPUT_ISO:
  cd image && ./build_os2borgerpc_image.sh {{INPUT_ISO}} {{OUTPUT_ISO}}

# Unpacks and mounts most images older than 4.0.0
mount-old-image IMG MOUNTPOINT:
  -just _umount-old-image {{MOUNTPOINT}}
  sudo mount {{IMG}} {{MOUNTPOINT}}
  # Note: In some cases this is not the name of the partition. In that case check the contents of the directory
  # manually, for whichever file is huge enough to be the relevant partition
  sudo gunzip --to-stdout {{MOUNTPOINT}}/os2borgerpc-images/os2borgerpc_default/vda2.ext4-ptcl-img.gz.aa > bpc-out-raw.img
  sudo partclone.extfs --source bpc-out-raw.img --restore --restore_raw_file --overwrite bpc-out.img
  -just _umount-old-image {{MOUNTPOINT}}
  sudo mount bpc-out.img {{MOUNTPOINT}}
  rm bpc-out-raw.img
