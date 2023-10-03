# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 13:38:49 by nicolas           #+#    #+#              #
#    Updated: 2023/10/03 19:42:06 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
# *				   VARIABLES				     * #
# **************************************************************************** #

NAME				:=		inception
COMPOSE				:=		docker compose -p $(NAME)
COMPOSE_FILE		:=		./srcs/docker-compose.yml

ENV_FILE			:=		./srcs/.env
FTP_CONTAINER_NAME	:=		ftp-server
FTP_USER_NAME		:=		${USER}
FTP_USER_PASSWORD	:=		$(shell grep 'FTP_USER_PASSWORD=' ${ENV_FILE} | cut -d '=' -f 2-)
FTP_IP				:=		$(shell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(FTP_CONTAINER_NAME))

# **************************************************************************** #
# *				    DEFINES				     * #
# **************************************************************************** #

define build_volumes

	if [ ! -d ~/data/wordpress ]; then \
		echo "[i] Building volume folder : ${HOME}/data/wordpress."; \
		mkdir -p ~/data/wordpress; \
	fi

	if [ ! -d ~/data/mariadb ]; then \
		echo "[i] Building volume folder : ${HOME}/data/mariadb."; \
		mkdir -p ~/data/mariadb; \
	fi

endef


define connect_to_ftp
	if docker ps -a --format '{{.Names}}' | grep -q '^${FTP_CONTAINER_NAME}$$'; then \
		echo "[i] Container '${FTP_CONTAINER_NAME}' is running."; \
		lftp -u ${FTP_USER_NAME},${FTP_USER_PASSWORD} -e "set ssl:verify-certificate no" $(FTP_IP); \
	else \
		echo "[i] Container '${FTP_CONTAINER_NAME}' not running."; \
	fi
endef

# **************************************************************************** #
# *				     RULES				     * #
# **************************************************************************** #

all:	up

up:
	@$(call build_volumes)
	@$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	@$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --rmi local

start:
	@$(call build_volumes)
	@$(COMPOSE) -f $(COMPOSE_FILE) start

stop:
	@$(COMPOSE) -f $(COMPOSE_FILE) stop

re:
	@$(call build_volumes)
	@$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

prune:
	@echo "[i] Prune all images."
	@docker image prune -af

clean:	down prune

fclean:	clean

lftp:
	@$(call connect_to_ftp)

system_prune:
	@echo "[i] Prune system images."
	@docker system prune -a


.PHONY: up down start stop re prune clean fclean lftp system_prune
