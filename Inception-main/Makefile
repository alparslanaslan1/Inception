COMPOSE_DIR := ./srcs
DATA_DIR := ${HOME}/data
COMPOSE_FILE := -f $(COMPOSE_DIR)/docker-compose.yml

all: up

up:
	mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb
	docker-compose $(COMPOSE_FILE) up --build

down:
	docker-compose $(COMPOSE_FILE) down

stop:
	docker-compose $(COMPOSE_FILE) stop

clean:
	docker-compose $(COMPOSE_FILE) down --volumes --remove-orphans

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	docker-compose $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans

re: fclean up

logs:
	docker-compose $(COMPOSE_FILE) logs -f

prune:
	@sudo rm -rf $(DATA_DIR)
	docker builder prune -a --force
	docker system prune -a --volumes --force
	docker volume prune --all --force

volume-rm:
	docker volume rm $(shell docker volume ls -qf dangling=true)


nginx mariadb wordpress: %:
	mkdir -p $(DATA_DIR)/$*
	docker-compose $(COMPOSE_FILE) up --build $*

.PHONY: all up down stop clean fclean re logs prune nginx mariadb wordpress
