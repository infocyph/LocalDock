# Use an official PHP Apache runtime
ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

# Required installations/updates
ARG LINUX_PACKAGES
RUN apt update && apt upgrade -y
RUN ["/bin/bash", "-c", "if [[ -n \"$LINUX_PACKAGES\" ]]; then apt install ${LINUX_PACKAGES//,/ } -y; fi"]

# Prepare prerequisites
ENV APACHE_LOG_DIR=/var/log/apache2
ADD ./apache/*.conf /etc/apache2/sites-available
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    rm -f /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf

# Configureing Apache
RUN a2enmod rewrite ssl socache_shmcb headers && a2ensite *

# Install PHP extensions
RUN ["/bin/bash", "-c", "install-php-extensions @composer ${PHP_EXTENSIONS//,/ }"]

# Install Node
ARG NODE_VERSION
RUN ["/bin/bash", "-c", "if [[ -n \"$NODE_VERSION\" ]]; then curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && apt install nodejs -y && npm i -g npm@latest; fi"]

RUN apt update &&  \
    apt install sudo -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Add synced system user
ARG UID
RUN useradd -G www-data,root -u $UID -d /home/devuser devuser && \
    mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser
USER devuser

WORKDIR /var/www/html
