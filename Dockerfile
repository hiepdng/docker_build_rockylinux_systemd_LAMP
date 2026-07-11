FROM rockylinux/rockylinux:9
ENV container=docker

RUN dnf -y install systemd; dnf clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
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

