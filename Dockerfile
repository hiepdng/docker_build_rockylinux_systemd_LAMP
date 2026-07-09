FROM rockylinux/rockylinux:9
ENV container=docker

# Install EPEL and Remi repositories for updated PHP packages
RUN <<EOF
dnf -y update
dnf install -y epel-release dnf-plugins-core
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf module enable -y php:remi-8.4
dnf -y install httpd
dnf -y install mysql-server
dnf -y install php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json
#dnf -y install mod_ssl
dnf clean all
EOF

RUN groupadd -g 1000 web
RUN groupadd -g 1100 data
RUN useradd --home /home/web_user --gid 1000 -m --shell /bin/bash --uid 1000 --comment "web_user" web_user
RUN useradd --home /home/data_user --gid 1100 -m --shell /bin/bash --uid 1100 --comment "data_user" data_user

# Expose HTTP port
EXPOSE 80 443 3306

# Copy and configure the startup script
COPY entrypoint_httpd_mysql.sh ./entrypoint_httpd_mysql.sh
RUN chmod +x ./entrypoint_httpd_mysql.sh

COPY entrypoint_httpd.sh ./entrypoint_httpd.sh
RUN chmod +x ./entrypoint_httpd.sh

COPY entrypoint_mysql.sh ./entrypoint_mysql.sh
RUN chmod +x ./entrypoint_mysql.sh

COPY index.php /var/www/html



VOLUME ["/var/log/nginx", "/var/www/html"]
VOLUME /data

