# Docker image for Chef Server

This Dockerfile installs and configure the Chef Server, Chef Manage, Chef Report. and Postfix for email notification as well.
Also, It creates `admin` user with password `admin123` by default. Please reset the password, email address and keys.

***This Dockerfile has been tested with Chef Server v12.15.8, v12.10.0, v12.9.1 and v12.9.0. It's not guarantee for any other versions, especially v11.x.***

## How to use this image

### Pull the image from Docker hub

```
docker pull sunggun/chef-server
```

### Run the Container

Run:
```bash
docker run -d --privileged \
  --name chef-server \
  -p 443:443 \
  sunggun/chef-server
```

Please check the log when you run/start/restart the chef-server. It takes a while until fully startup.
```bash
docker logs -f chef-server
```

To verify chef-server version:
```bash
docker exec -it chef-server cat /opt/opscode/version-manifest.json | grep build_version
```

### Using volume for data storage
The Dockerfile defines mount points i order to support storing config, data ,and data backup in your storage.

* `/etc/opscode`: Chef server home.
* `/var/opt/opscode`: Data directory for all components.
* `/var/opt/chef-backup`: Data backup directory. If you run the `chef-server-ctl backup` in the running container, the backup data archive will be stored in this directory.

```bash
docker run -d --privileged \
  --name chef-server \
  -v <your-chef-home-directory>:/etc/opscode:rw \
  -v <your-data-directory>:/var/opt/opscode:rw \
  -v <your-backup-directory>:/var/opt/chef-backup:rw \
  -h <your-hostname> \
  -p 443:443 \
  sunggun/chef-server
```

## Get admin user and default group key.

Execute the following cli to find the keys.

`admin` user key:
```bash
docker exec -it chef-server cat /etc/opscode/admin.pem
```

`default` group validator key:
```bash
docker exec -it chef-server cat /var/opscode/default-validator.pem
```

## Access to the Chef Manage Console

You can access and login to the chef manage console through web browser.
```
https://<your-host>
```
please use user name `admin` and password `admin123` to login. and don't forget to reset password and key once you login.


## Build the Image

Build latest version: current latest is 12.15.8
```bash
docker build -t chef-server:latest -t chef-server:12.15.8 .
```

For my workflow :-)
```bash
docker build -t sunggun/chef-server:latest -t sunggun/chef-server:12.15.8 .
```

To build the `chef-server` image with specific version such as `12.9.1`, you need to pass `CHEF_SERVER_VERSION` and `CHEF_SERVER_DOWNLOAD_SHA1` build-arg.
Please find the `VERSION` and `SHA1` for `Ubuntu Linux 14.04 x86_64` from <https://downloads.chef.io/chef-server/ubuntu/>

```bash
docker build \
  --build-arg CHEF_SERVER_VERSION=12.9.1 \
  --build-arg CHEF_SERVER_DOWNLOAD_SHA1=487c5ca8e42c65aadd5ff1a4c885ac4f0acefa2c \
  -t chef-server:12.9.1 \
  .
```

For my workflow:
```bash
docker build \
  --build-arg CHEF_SERVER_VERSION=12.9.1 \
  --build-arg CHEF_SERVER_DOWNLOAD_SHA1=487c5ca8e42c65aadd5ff1a4c885ac4f0acefa2c \
  -t sunggun/chef-server:12.9.1 \
  .
```
