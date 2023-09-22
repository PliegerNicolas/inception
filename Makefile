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

NAME			:=		inception

COMPOSE			:=		docker compose -p $(NAME)
COMPOSE_FILE		:=		./srcs/docker-compose.yml

all:	up

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --rmi local

start:
	$(COMPOSE) -f $(COMPOSE_FILE) start

stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

re:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

prune:
	docker image prune -af

clean:	down prune


.PHONY: up down start stop re prune clean
