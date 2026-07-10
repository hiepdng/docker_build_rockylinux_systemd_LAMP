FROM rockylinux/rockylinux:9
ENV container=docker

RUN dnf -y install systemd; dnf clean all

# Install EPEL and Remi repositories for updated PHP packages
RUN <<EOF
dnf -y update
dnf install -y epel-release dnf-plugins-core
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf module reset php -y
dnf module enable php:remi-8.4 -y
dnf -y install httpd
dnf -y install mysql-server
dnf -y install php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json
#dnf -y install mod_ssl
dnf -y install procps-ng
dnf clean all
EOF

RUN groupadd -g 1000 web
RUN groupadd -g 1100 data
RUN useradd --home /home/web_user --gid 1000 -m --shell /bin/bash --uid 1000 --comment "web_user" web_user
RUN useradd --home /home/data_user --gid 1100 -m --shell /bin/bash --uid 1100 --comment "data_user" data_user

# Expose HTTP port
EXPOSE 80 443 3306

# Copy and configure the startup script
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

COPY index.php /var/www/html

VOLUME /sys/fs/cgroup
VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /etc/apache2

CMD ["/usr/sbin/init"]

