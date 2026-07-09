#!/bin/bash

# Initialize MariaDB data directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
echo "Starting MariaDB..."
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

# Wait for MariaDB to fully boot up
echo "Waiting for MariaDB to start..."
until mysqladmin ping &>/dev/null; do
    sleep 1
done

# Secure / set root password if needed (Optional: change 'secretpassword')
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secretpassword'; FLUSH PRIVILEGES;"

# Start Apache HTTPD in the foreground
echo "Starting Apache HTTP Server..."
exec /usr/sbin/httpd -DFOREGROUND
