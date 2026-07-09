#!/bin/bash

# Ensure MySQL directories have correct permissions
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld /var/lib/mysql


# Initialize and start MySQL
if [ ! -d '/var/lib/mysql/mysql' ]; then
  mysqld --initialize-insecure;
fi;
exec mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking=0


# Wait for MySQL to fully boot up
echo "Waiting for MySQL to start..."
until mysqladmin ping &>/dev/null; do
    sleep 1
done

# Secure / set root password if needed (Optional: change 'secretpassword')
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secretpassword'; FLUSH PRIVILEGES;"
mysql -u root -e "CREATE USER 'mysql'@'localhost' IDENTIFIED BY 'secretpassword'";
