#!/bin/sh

export OS=Debian8

python -m SimpleHTTPServer & 2> /dev/null
child_pid=$!
trap "kill $child_pid ; virsh undefine $OS" INT QUIT TERM

virt-install \
--connect qemu:///session \
--name ${OS} \
--ram 512 \
--vcpus 1 \
--file ${OS}.qcow2 \
--file-size=4 \
--controller type=scsi,model=virtio-scsi \
--location http://deb.debian.org/debian/dists/stable/main/installer-amd64/ \
--virt-type kvm \
--os-variant Debian8 \
--network=user \
--noreboot \
--graphics none \
--console pty,target_type=serial \
--extra-args "auto=true hostname=${OS} domain= url=http://10.0.2.2:8000/vanilla-debian-8-jessie-preseed.cfg console=ttyS0,115200n8 DEBIAN_FRONTEND=text"

kill $child_pid
virsh undefine $OS
