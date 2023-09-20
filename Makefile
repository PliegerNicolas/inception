# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nplieger <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/18 17:27:57 by nplieger          #+#    #+#              #
#    Updated: 2023/09/19 15:37:56 by nplieger         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			:=		inception

COMPOSE			:=		docker compose -p $(NAME)
COMPOSE_FILE		:=		./srcs/docker-compose.yml

all:	up

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi local

start:
	$(COMPOSE) -f $(COMPOSE_FILE) start

stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

re:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

clean:	down

.PHONY: up down start stop re clean
