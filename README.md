
# Inception

This project aims to broaden my knowledge of system administration by using Docker.

THIS PROJECT IS NOT FUNCTIONNAL NOR FINISHED.

## Dependencies

1. You need `Docker` and `docker compose`. You can figure out how to install it [here](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
2. You need make. You can download it with `apt update && apt install make` in Ubuntu. Check out your current package manager.

## Subject

- A `Makefile` should exist to facilitate application launch.
- Docker Compose should be used (via `docker-compose.yml` file and `Dockerfile`).
- Three containers should exist and cohabitate on the same `docker-network` :
    - Containers :
        - `NGINX` with `TLSv1.2` or `TLSv.1.3` only.
        - `WordPress` + `php-fpm`. No NGINX.
        - `MariaDB`.
- Only the penultimate debian or alpine images are permitted. I should build my own images from them. See [docker hub](https://hub.docker.com/).
- The NGINX container should be the only entrypoint to my infrastructure via `port 443` (HTTPS).
- MariaDB should have 2 users : administrator user and lambda user.
- MariaDB and WordPress's content should be persistent and stored and host computer via `volumes` at `/home/${NAME}/data`.
- On crash, the containers should restart.
- The domain name must be `${name}.42.fr` (and `www.${name}.42.fr` optionnally).
- The 'latest' tag is prohibited.
- Environment variables are mandatory. `.env` file should be located in the same directory as the `docker-compose.yml` file. Technically, `.env` shouldn't be available in github per security reasons. [Here](#environnement-file-env) is a model If you want to build your own.
- The project's structure should be as [follows](#project-structure).

## Project structure

The project should be structured something like this but liberties can be taken of course.

```
.
├── Makefile
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb
        │   ├── conf
        │   ├── Dockerfile
        │   └── .dockerignore
        ├── nginx
        │   ├── conf
        │   ├── Dockerfile
        │   └── .dockerignore
        └── wordpress
            ├── conf
            ├── Dockerfile
            └── .dockerignore
```

## Project setup

To setup a new local `domain name` you can go to ...

```sudo nano /etc/hosts```

And complete the file as this :     
`${USER}` is not available in `/etc/hosts` and should be `hard-coded`.

```
# This file describes a number of hostname-to-address
# mappings for the TCP/IP subsystem. It is mostly
# used at boot time, when no name servers are running.
# On small systems, this file can be used instead of a
# "named" name server.

# Syntax:
# IP-Address  Full-Qualified-Hostname  Short-Hostname

127.0.0.1       localhost
127.0.0.1       ${USER}.42.fr www.${USER}.42.fr

# special IPv6 addresses
::1             localhost ip6-localhost ip6-loopback

fe00::0         ip6-localnet

ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
ff02::3         ip6-allhosts

# End of file
```

## Environnement file (.env)

```
APP_USER=${USER}
DOMAIN_NAME=${APP_USER}.42.fr

# certificates
CERTS_=/etc/nginx/ssl/certificates

# MYSQL SETUP
DB_TITLE=db_wordpress
DB_HOST=mariadb
DB_ROOT_PASSWORD=RootPassword123

# USER
DB_USER_NAME=${APP_USER}
DB_USER_PASSWORD=Password123
```
