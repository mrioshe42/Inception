#!/bin/bash

# Get password from secrets
if [ -f "/run/secrets/ftp_password" ]; then
    FTP_PASS=$(cat /run/secrets/ftp_password)
else
    echo "Error: FTP password secret not found"
    exit 1
fi

# Create FTP user
echo "Creating FTP user ${FTP_USER}..."
adduser --disabled-password --gecos "" "${FTP_USER}"
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

mkdir -p /var/run/vsftpd/empty
mkdir -p /var/www/html

chown -R "${FTP_USER}":www-data /var/www/html
chmod -R 775 /var/www/html

echo "FTP Server is starting..."
echo "User ${FTP_USER} is configured."
echo "Root directory is /var/www/html"

exec vsftpd /etc/vsftpd.conf
