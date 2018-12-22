# Lychee + Docker

[![Docker Stars](https://img.shields.io/docker/stars/kolex/lychee.svg?style=flat-square)](https://hub.docker.com/r/kolex/lychee/)
[![Docker Pulls](https://img.shields.io/docker/pulls/kolex/lychee.svg?style=flat-square)](https://hub.docker.com/r/kolex/lychee/)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/kolex/lychee.svg?style=flat-square)](https://hub.docker.com/r/kolex/lychee)


![Lychee](https://i.imgur.com/bupJVBj.png)

## What is Lychee?

Lychee is a free photo-management tool, which runs on your server or web-space. Installing is a matter of seconds. Upload, manage and share photos like from a native application. Lychee comes with everything you need and all your photos are stored securely.

Feel free to check out our image on the [Docker Hub](https://hub.docker.com/r/kolex/lychee) as well!

## Features

- Based on nginx-alpine
- Uses the latest release from [LycheeOrg/Lychee](https://github.com/LycheeOrg/Lychee)
- For additional security, the checksum of the downloaded binary will be verified during the build process.
- Does not run as root (uses the provided "nginx" user)
- No usage of ```chmod 777``` as used by many other images

## Description

This image contains a working Lychee installation which uses the nginx:1.15.7-alpine image. The base images provides alpine with nginx installed, we've added php7 and the Lychee files. We've tried to do everything as small, secure and clean as possible, but if you find some spots which need to be improved, feel free to tell us.

## Usage

Please note that Lychee requires a MySQL/MariaDB database. If you do not have one already, keep in mind that running the following command will not be of any use for you. In this case check out the docker-compose example below.

```docker
docker run -d -it \
  --name lychee \
  --restart unless-stopped \
  -p 80:80 \
  -v /path/to/host/config:/var/www/html/data \
  -v /path/to/host/images:/var/www/html/uploads \
  kolex/lychee:3.2.7
```

The docker-compose example below (also available as a file  [right here](https://github.com/konstantingoretzki/lychee-docker/blob/master/docker-compose.yml)) makes it easy to get Lychee running, as it includes a MariaDB database. It also creates the config/images volumes for your persistant data.

Please replace the password variables with your own secure passwords and save it as "docker-compose.yml". You can run the stack by executing ```docker-compose up -d``` in the same directory as the file.

After opening the webinterface for the first time you will be asked for the database credentials. If you are using our docker-compose example, it could look like this:

- **Database host**: db
- **Database username**: lychee
- **Database password**: YOURSAFEPASSWORD2
- **Database name**: lychee

Setup your admin credentials afterwards and you're good to go!

**Important**: It is heavily reccommended to remove both of the MYSQL password lines from your docker-compose.yml after a successful installation, as those will be persistantly stored in the image volumes and thus aren't required for starting/stopping the container.


```yml
version: '3'
services:
  lychee:
    image: kolex/lychee:3.2.7
    container_name: lychee
    restart: unless-stopped
    ports:
      - 80:80
    networks:
      - lychee
    volumes:
      - config:/var/www/html/data
      - images:/var/www/html/uploads

  db:
    image: mariadb
    container_name: lychee_db
    restart: unless-stopped
    networks:
     - lychee
    volumes:
     - db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: <YOURSAFEPASSWORD1>
      MYSQL_DATABASE: lychee
      MYSQL_USER: lychee
      MYSQL_PASSWORD: <YOURSAFEPASSWORD2>

networks:
  lychee:

volumes:
  config:
  images:
db:
```
