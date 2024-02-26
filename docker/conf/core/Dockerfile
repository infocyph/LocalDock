# Use an official PHP Apache runtime
ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

# Required installations/updates
RUN apt update && apt upgrade -y && apt install locales curl git -y

# Configureing Apache
ENV APACHE_LOG_DIR=/var/log/apache2
RUN a2enmod rewrite ssl socache_shmcb headers
ADD ./sites/*.conf /etc/apache2/sites-available
RUN rm -rf /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf && \
    a2ensite *

# Install PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions @composer gettext pdo_mysql mysqli bcmath zip gd

# Install mkcert (for local certificate generation, if required)
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
    chmod +x mkcert-v*-linux-amd64 && \
    cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert

# Install Node LTS (latest)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt install nodejs -y && npm i -g npm@latest

RUN apt install sudo -y && apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Add synced system user
ARG UID
RUN useradd -G www-data,root -u $UID -d /home/devuser devuser && \
    mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser
USER devuser

WORKDIR /var/www/html
