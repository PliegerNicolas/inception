# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nplieger <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/18 17:27:57 by nplieger          #+#    #+#              #
#    Updated: 2023/09/19 15:13:56 by nplieger         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			:=		inception

COMPOSE			:=		docker-compose
COMPOSE_FILE		:=		./srcs/docker-compose.yml

all:	up

up:
	$(COMPOSE) -p $(NAME) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

re:
	$(COMPOSE) -p $(NAME) -f $(COMPOSE_FILE) up -d --build

clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi all

.PHONY: up down re clean
