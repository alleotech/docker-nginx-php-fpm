FROM centos:centos7

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Nginx with PHP-FPM Docker Image" \
    org.label-schema.vendor="AlleoTech" \
    org.label-schema.livence="MIT" \
    org.label-schema.build-data="2019040601"

MAINTAINER AlleoTech <admin@alleo.tech>

ARG PHP_VERSION=71

# Enable Networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Install EPEL & REMI
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable epel \
    && yum-config-manager --enable remi-php${PHP_VERSION}


# Install PHP and Tools 
RUN yum -y install --setopt=tsflags=nodocs openssh-clients \
    php-cli \
    php-common \
    php-gd \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pecl-apcu \
    php-process \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-fpm \
	nginx \
    cronie \
    rsync \
    git \
    vim \
    htop \
    mtr \
    telnet \
    links \
    && yum clean all \
    && rm -rf /var/cache/yum

# Configure things
RUN sed -i -e 's~^;date.timezone =$~date.timezone = UTC~g' /etc/php.ini \
	&& mkdir -p /etc/nginx/conf.d/000-default \
	&& mkdir -p /var/www/html/000-defualt/webroot \
	&& mkdir -p /var/www/html/000-default/webroot/.well-known \
	&& mkdir -p /run/php-fpm \
	&& mkdir -p /var/cache/nginx/fastcgi \
	&& chown nobody:nobody /var/lib/php -R \
	&& chown nobody:nobody /var/cache/nginx -R \
	&& chown nobody:nobody /var/lib/nginx -R \
	&& echo '<?php phpinfo(); ?>' > /var/www/html/000-default/webroot/index.php

COPY nginx.conf /etc/nginx/nginx.conf
COPY vhost.conf /etc/nginx/conf.d/000-default/vhost.conf
COPY pool.conf /etc/php-fpm.d/www.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/entrypoint.sh"]
