#!/bin/sh

echo "[i] Append conf.d inclusion to vsftpd.conf file."
cat /etc/vsftpd/conf.d/*.conf >> /etc/vsftpd/vsftpd.conf

echo "[i] Create FTP user in non-interactive login mode."
adduser ${FTP_USER_NAME} -s /bin/false ${FT_USER_NAME}

echo "[i] Set the FTP user's password."
echo "${FTP_USER_NAME}:${FTP_USER_PASSWORD}" | chpasswd

echo "[i] Create /var/www/html if not already existant in volume and give permissions to FTP user."
mkdir -p /var/www/html
chown -R ${FTP_USER_NAME} /var/www/html

echo "[i] Create vsftpd.userlist and add our FTP user to it."
echo ${FTP_USR_NAME} > /etc/vsftpd/vsftpd.userlist &> /dev/null

exec "$@"
