Docker image for Chef Server
============================

This Dockerfile installs and configure the Standalone Chef Server, Chef Manage and Report for `Ubuntu Linux 14.04 x86_64` on the `ubuntu:14.04` Docker Image. 
Also, It creates `admin` user with password `admin123` and `default` group by default. Please reset the password, email address and keys after you run the container.

***This Dockerfile has tested in Chef Server v12.10.0, v12.9.1 and v12.9.0. It not guarantee for any other versions, especially v11.x.***

## Build the Image

Build latest version : current latest is 12.10.0
```bash
docker build -t chef-server:latest -t chef-server:12.10.0 .
```

For my workflow :-)
```bash
docker build -t sunggun/chef-server:latest -t sunggun/chef-server:12.10.0 .
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

For my workflow :
```bash
docker build \
  --build-arg CHEF_SERVER_VERSION=12.9.1 \
  --build-arg CHEF_SERVER_DOWNLOAD_SHA1=487c5ca8e42c65aadd5ff1a4c885ac4f0acefa2c \
  -t sunggun/chef-server:12.9.1 \
  .
```

## Run the Container

Run :
```bash
docker run -d --privileged \
  --name chef-server \
  -p 443:443 \
  chef-server
```

Please check the log when you run/start/restart the chef-server. It takes a while until fully startup.
```bash
docker logs -f chef-server
```

To verify chef-server version :
```bash
docker exec -it chef-server cat /opt/opscode/version-manifest.json | grep build_version
```

## Get admin user and default group key.

Execute the following cli to find the keys.

`admin` user key :
```bash
docker exec -it chef-server cat /var/opt/chef-server/admin.pem
```

`default` group validator key :
```bash
docker exec -it chef-server cat /var/opt/chef-server/default-validator.pem
```

## Access to the Chef Manage Console

You can access and login to the chef manage console through web browser. 
```
https://<your-host>
```

please use user name `admin` and password `admin123` to login. and don't forget to reset password and key once you login.

```
https://<your-host>/organizations/default/users/admin
```