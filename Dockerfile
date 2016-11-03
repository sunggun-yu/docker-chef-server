FROM ubuntu:14.04
MAINTAINER Sunggun Yu <sunggun.dev@gmail.com>

RUN set -x \
    && mkdir -p /var/opt/chef-server

WORKDIR /var/opt/chef-server

# Install and wget
RUN set -x \
    && apt-get update \
    && apt-get install -y wget ca-certificates apt-transport-https telnet curl htop vim \
    && rm -rf /var/lib/apt/lists/*

ENV CHEF_SERVER_VERSION 12.10.0
ENV CHEF_SERVER_DOWNLOAD_URL https://packages.chef.io/stable/ubuntu/14.04/chef-server-core_"$CHEF_SERVER_VERSION"-1_amd64.deb
ENV CHEF_SERVER_DOWNLOAD_SHA1 95fce9f167972418b3f06b9e5fe95f8a3f0e5361

# Download Chef-Server package file
RUN set -x \
    && wget --no-check-certificate -O chef-server-core_"$CHEF_SERVER_VERSION"-1_amd64.deb "$CHEF_SERVER_DOWNLOAD_URL" \
    && echo "$CHEF_SERVER_DOWNLOAD_SHA1 chef-server-core_$CHEF_SERVER_VERSION-1_amd64.deb" | sha1sum -c -

# Install Chef-Server package
RUN set -x \
    && dpkg -i chef-server-core_"$CHEF_SERVER_VERSION"-1_amd64.deb \
    && dpkg-divert --local --rename --add /sbin/initctl \
    && ln -sf /bin/true /sbin/initctl \
    && rm chef-server-core_"$CHEF_SERVER_VERSION"-1_amd64.deb

COPY entrypoint.sh /

# Execute entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Expose ports
EXPOSE 443
