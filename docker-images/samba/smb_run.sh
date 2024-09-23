#!/bin/sh

# Edit samba config
sed -i "s/workgroup = HOME/workgroup = $WORKGROUP/" /etc/samba/smb.conf
sed -i "s/netbios name = FILES/netbios name = $MACHINE_NAME/" /etc/samba/smb.conf
sed -i "s/valid users = 1000/valid users = $USER_NAME/" /etc/samba/smb.conf

adduser -G users -D -H -u $PUID $USER_NAME
(echo "$USER_PASSWORD"; echo "$USER_PASSWORD") | smbpasswd -s -a $USER_NAME

wsdd2 -H $MACHINE_NAME -N $MACHINE_NAME -G $WORKGROUP -d

smbd --foreground
