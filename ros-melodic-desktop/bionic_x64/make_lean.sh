#!/bin/bash

# pkgs with no rdepends and not used :

# this seems to break apt, FIXME: is it necessary ?
# apt-get purge -y \
# 	desktop-file-utils \
# 	gnome-control-center-data \
# 	gnome-control-center-faces \
# 	gnome-online-accounts \
# 	libcheese-gtk25:amd64 \
# 	libcolord-gtk1:amd64 \
# 	libpwquality1:amd64 \
# 	rygel \
# 	tcpdump \
# 	whoopsie-preferences \
# 	xserver-xephyr

# clean apt caches

rm -rf /var/lib/apt/lists/*



