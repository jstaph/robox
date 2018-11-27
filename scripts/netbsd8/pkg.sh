#!/bin/sh

set -x

# Ensure the pkg utilities are in the path.
export PATH="/usr/sbin/:/usr/pkg/bin/:$PATH"

# Dictate the package repository.
export PKG_PATH="http://ftp.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/8.0/All"

# Add the packages.
pkg_add vim curl wget sudo bash pkgin slocate bash-completion

# Enable the binary package repositories.
sed -i 's,^[^#].*$,http://ftp.NetBSD.org/pub/pkgsrc/packages/NetBSD/$arch/8.0/All,' /usr/pkg/etc/pkgin/repositories.conf

# Link up the bash target so script headers work properly.
if [ ! -f /bin/bash ] && [ -f /usr/pkg/bin/bash ]; then
  ln -s /usr/pkg/bin/bash /bin/bash
fi

# Make bash the default shell.
chsh -s bash root

# Setup the locate database.
cp /usr/pkg/share/examples/slocate/updatedb.conf /etc/updatedb.conf

# Create the database folder.
if [ ! -d /var/lib/ ]; then
  mkdir /var/lib/
fi

# Create the database folder.
if [ ! -d /var/lib/slocate/ ]; then
  mkdir /var/lib/slocate/
fi

# On some systems, the mtab file isn't created automatically, which causes
# spurious slocate errors.
if [ ! -f /etc/mtab ]; then
  touch /etc/mtab
fi

# Update the package database.
/usr/pkg/bin/updatedb

# Auto update the database.
printf "\n16 * * * * /usr/pkg/bin/updatedb\n" >> /var/cron/tabs/root

# Make the path, and package repo variables persistent.
echo 'export PATH="/usr/sbin/:/usr/pkg/bin/:$PATH"' >> /etc/profile
echo 'export PKG_PATH="http://ftp.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/8.0/All"' >> /etc/profile

# Load the bash helpers.
echo 'source /usr/pkg/share/bash-completion/bash_completion' >> /etc/profile
