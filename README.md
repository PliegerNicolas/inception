
# Inception

This project aims to broaden my knowledge of system administration by using Docker.

By using 'make' you should be able to deploy a functionnal wordpress website on https://localhost (and optionally https://${USER}.42.fr or https://www.${USER}.42.fr).

## Dependencies & necessities

1. You need `Docker` and `docker compose`. You can figure out how to install it [here](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
2. You need `make`. You can download it with `apt update && apt install make` in Ubuntu. Check out your current package manager.
3. [optional] You need `lftp` if you want to connect via ftp to your wordpress website using SSL.

This project with create the ${HOME}/data folder for persistent memory storage (volumes). The HOME env variable should exist.
This project will build based on the $USER env variable (domain name, wordpress user, mariadb user). The USER env variable should exist.

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
- MariaDB and WordPress's content should be persistent and stored and host computer via `volumes` at `${HOME}/data`.
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

To setup na new local `domain name` you can use the following command :
```
sudo echo "127.0.0.1    ${USER}.42.fr www.${USER}.42.fr" >> /etc/hosts
```

If you want to handle this more cleanly, you can go to `/etc/hosts` and add the line by hand. But that file hasn't access to environment variables so ${USER} should be filled in by hand.

## Environnement file (.env)

```
# **************************************************************************** #
# *                                 MANDATORY                                * #
# **************************************************************************** #

DOMAIN_NAME=${USER}.42.fr

# certificates
NGINX_CERTS=/etc/nginx/ssl/certificates
FTP_CERTS=/etc/vsftpd/ssl/certificates

# MYSQL SETUP
DB_TITLE=db_wordpress
DB_HOST=mariadb
DB_ROOT_PASSWORD=RootPassword123
DB_USER_NAME=${USER}
DB_USER_PASSWORD=Password123

# WEBSITE
HTML_PATH=/var/www/html
WP_PATH=${HTML_PATH}/wordpress

# **************************************************************************** #
# *                                   BONUS                                  * #
# **************************************************************************** #

# WEBSITE
STATIC_PATH=${HTML_PATH}/static
ADMINER_PATH=${HTML_PATH}/adminer

# Redis
REDIS_HOST=redis

# FTP
FTP_USER_NAME=${USER}
FTP_USER_PASSWORD=Password123
```

## Bonus

A Dockerfile must be written for each extra service. Thus, each one of them will run
inside its own container and will have, if necessary, its dedicated volume.

TODO :
- Set up redis cache for your WordPress website in order to properly manage the
cache.
- Set up a FTP server container pointing to the volume of your WordPress website.
- Create a simple static website in the language of your choice except PHP (Yes, PHP
is excluded!). For example, a showcase site or a site for presenting your resume.
- Set up Adminer.
- Set up a service of your choice that you think is useful. During the defense, you
will have to justify your choice.
