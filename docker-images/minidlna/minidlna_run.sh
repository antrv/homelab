#!/bin/sh

sed -i "s/#friendly_name=.*/friendly_name=$FRIENDLY_NAME/" /etc/minidlna.conf

exec /usr/sbin/minidlnad -d -u $PUID -g $PGID
