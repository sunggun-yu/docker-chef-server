Docker image for Chef Server
============================

This Dockerfile installs the chef-server and chef-manage. It also generate `admin` user with password `admin123` by default.

## Build the Image
```
docker build -t chef-server .
```

## Run the Container
```
docker run -d --privileged \
  --name chef-server \
  -p 443:443 \
  chef-server
```

## Get admin user key file
Execute the following cli after run the docker-server container.
```
docker exec -it chef-server cat /var/opt/chef-server/admin.pem
```
