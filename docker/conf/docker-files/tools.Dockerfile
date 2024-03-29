FROM debian:latest

# Required/Common Packages
RUN apt update && apt upgrade -y
RUN apt install python3 python3-pip curl git wget net-tools libnss3-tools \
    build-essential python3-dev libcairo2-dev libpango1.0-dev ffmpeg -y && \
    rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED

# mkcert
RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64" && \
    chmod +x mkcert-v*-linux-amd64 && \
    cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert && \
    rm -f mkcert-v*-linux-amd64 && \
    mkdir -p /etc/ssl/custom

# lazydocker
ENV DIR=/usr/local/bin
RUN curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# git fame
RUN pip install git-fame && git config --global alias.fame '!python3 -m gitfame' && \
    wget -O /usr/local/bin/owners https://raw.githubusercontent.com/abmmhasan/misc-ref/main/git/owners.sh && \
    chmod +x /usr/local/bin/owners

# Git story
RUN pip install manim gitpython git-story

# Add sudo & clean up
RUN apt update &&  \
    apt install sudo -y &&  \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Add synced system user
ARG UID
RUN useradd -G root -u ${UID} -d /home/devuser devuser && \
    mkdir -p /home/devuser && \
    chown -R devuser:devuser /home/devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devuser
USER devuser

WORKDIR /app

CMD ["tail", "-f", "/dev/null"]
