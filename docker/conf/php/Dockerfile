# Use an official PHP Apache runtime
ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# Required installations/updates
RUN apt update && apt upgrade -y && apt install locales curl git -y

RUN apt install sudo -y && apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Add synced system user
ARG UID
RUN useradd -G www-data,root -u $UID -d /home/devuser devuser && \
    mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser
USER devuser

WORKDIR /app