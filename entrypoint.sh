#!/bin/bash

### Configure php-fpm:
# modify /etc/php-fpm.d/www.conf
/usr/bin/sed -i 's/listen.acl_users = apache,nginx/;listen.acl_users = apache,nginx/g' /etc/php-fpm.d/www.conf
/usr/bin/sed -i 's/;listen.owner = nobody/listen.owner = apache/g' /etc/php-fpm.d/www.conf
/usr/bin/sed -i 's/;listen.group = nobody/listen.group = apache/g' /etc/php-fpm.d/www.conf
/usr/bin/sed -i 's/;listen.mode = 0660/listen.mode = 0600/g' /etc/php-fpm.d/www.conf

# start php-fpm service
/usr/bin/systemctl enable php-fpm.service
/usr/bin/systemctl start php-fpm.service


### Configure MySQL:
# Ensure MySQL directories have correct permissions
/usr/bin/mkdir -p /var/run/mysqld
/usr/bin/chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Initialize and start MySQL
if [ ! -d '/var/lib/mysql/mysql' ]; then
  /usr/bin/mysqld --initialize-insecure;
fi;

# Wait for MySQL to completely start up
/usr/bin/systemctl enable mysqld.service
/usr/bin/systemctl start mysqld.service

# Wait for MySQL to fully boot up
/usr/bin/echo "Waiting for MySQL to start..."
until mysqladmin ping &>/dev/null; do
    /usr/bin/sleep 1
done

# Secure / set root password if needed (Optional: change 'secretpassword')
/usr/bin/mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secretpassword'; FLUSH PRIVILEGES;"


### Configure Apache:
# Start Apache HTTPD in the foreground
/usr/bin/echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
/usr/bin/systemctl enable httpd.service
/usr/bin/systemctl start httpd.service

