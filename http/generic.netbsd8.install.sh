#!/bin/sh

mount /dev/sd0a /mnt

sed -i 's/^#UseDNS no/UseDNS no/' /mnt/etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' /mnt/etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /mnt/etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /mnt/etc/ssh/sshd_config

printf "sshd=YES\n" >> /mnt/etc/rc.conf
printf "dhcpcd=YES\n" >> /mnt/etc/rc.conf
printf "ntpdate=YES\n" >> /mnt/etc/rc.conf
