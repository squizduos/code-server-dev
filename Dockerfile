FROM ubuntu:18.04

LABEL ru.squizduos.image squizduos/dev-server
LABEL ru.squizduos.maintainer squizduos <squizduos@gmail.com>
LABEL ru.squizduos.url https://squizduos.ru
LABEL ru.squizduos.github https://github.com/squizduos
LABEL ru.squizduos.registry https://registry.squizduos.ru


ARG VERSION='2.1692-vsc1.39.2' 
 
ENV TZ='Europe/Moscow'
ENV PASSWORD="changeme"
ENV LANG="ru_RU.UTF-8"

ARG DEBIAN_FRONTEND=noninteractive

# Set time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install core dependencies
RUN apt-get update && \
    apt-get upgrade -y &&
    apt-get install -y \
        build-essential \
        ca-certificates \
        software-properties-common \
        apt-utils \
        dumb-init \
        curl \
        git \
        jq \
        locales \
        make \
        man-db \
        net-tools \
        openssl \
        screen \	
        sudo \
        wget \
        unzip

# Locale Generation
RUN locale-gen en_US.UTF-8 && \
    locale-gen $LANG

ENV LOCALE=$LANG \
    LC_ALL='en_US.UTF-8' \
	SHELL=/bin/bash

# Install Coder
RUN export CODE_SERVER="code-server"$VERSION"-linux-x86_64" && \
    mkdir -p /tmp/data && \
    wget https://github.com/cdr/code-server/releases/download/"$VERSION"/${CODE_SERVER}.tar.gz -qO /tmp/data/${CODE_SERVER}.tar.gz && \
    tar -xzf /tmp/data/${CODE_SERVER}.tar.gz -C/tmp/data&& \
    mv /tmp/data/"$CODE_SERVER"/code-server /usr/local/bin && \
    rm -rf /tmp/data

# Add new user `dev`
RUN adduser --gecos '' --disabled-password dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER dev

RUN mkdir -p /home/dev

WORKDIR /home/dev

VOLUME [ "/home/dev" ]

# Install all
COPY install.sh /tmp/install.sh

RUN sudo bash /tmp/install.sh

ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

EXPOSE 8000-8100

COPY sync-extensions.sh /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["dumb-init", "/usr/local/bin/docker-entrypoint.sh"]
