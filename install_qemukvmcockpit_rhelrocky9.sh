#!/bin/bash
#this script uses rhel 9 instructions to install virtualization
#most of these commands were copy/pasted from the RHEL guide online: 
#https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization


#install deps
dnf install qemu-kvm libvirt virt-install virt-viewer -y

sleep 5

#start interfaces
for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done

sleep 5

#validate everything works
virt-host-validate

#install cockpit UI
dnf install cockpit -y
sleep 5
#enable to run
systemctl enable --now cockpit.socket
sleep 5
#allow firewall, runs on port 9090
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload

#open firefox as regular user
su - $USER -c "firefox http://localhost:9090" &

