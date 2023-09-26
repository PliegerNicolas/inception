# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 13:38:49 by nicolas           #+#    #+#              #
#    Updated: 2023/09/21 17:00:48 by nicolas          ###   ########.fr        #
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
	@echo "[i] Building volume folders if needed."
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/mysql
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

system_prune:
	@echo "[i] Prune system images."
	@docker system prune -a

.PHONY: up down start stop re prune clean system_prune
