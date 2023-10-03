#!/bin/sh

echo "[i] Configure SSL."
cat <<EOL >> /etc/vsftpd/vsftpd.conf

# Configure SSL.

# Enable TLS
ssl_enable=YES

# SSL certificate an private key paths.
rsa_cert_file=${FTP_CERTS}/${DOMAIN_NAME}.crt
rsa_private_key_file=${FTP_CERTS}/${DOMAIN_NAME}.key
EOL

echo "[i] Set permission to vsftpd to access SSL certifications."
chown -R vsftpd:vsftpd ${FTP_CERTS}/ && chmod -R 400 ${FTP_CERTS}/

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
echo "${FTP_USER_NAME}" > /etc/vsftpd/vsftpd.userlist

exec "$@"
