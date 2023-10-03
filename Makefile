# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 13:38:49 by nicolas           #+#    #+#              #
#    Updated: 2023/10/03 13:25:56 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
# *				   VARIABLES				     * #
# **************************************************************************** #

NAME			:=		inception
COMPOSE			:=		docker compose -p $(NAME)
COMPOSE_FILE		:=		./srcs/docker-compose.yml

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

system_prune:
	@echo "[i] Prune system images."
	@docker system prune -a

.PHONY: up down start stop re prune clean fclean system_prune
