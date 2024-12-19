NAME= inception

all: prepare $(NAME)

prepare:
	@mkdir -p /home/mrios-he/data/wordpress
	@mkdir -p /home/mrios-he/data/mariadb
	@mkdir -p /home/mrios-he/data/hugo
	@sudo chmod 777 /home/mrios-he/data/hugo
	@sudo chmod 777 /home/mrios-he/data/wordpress
	@sudo chmod 777 /home/mrios-he/data/mariadb
	@sudo chown -R mrios-he:mrios-he /home/mrios-he/data/wordpress
	@sudo chown -R mrios-he:mrios-he /home/mrios-he/data/mariadb
	@sudo chown -R mrios-he:mrios-he /home/mrios-he/data/hugo
	@sudo sed -i '/mrios-he.42.fr/d' /etc/hosts
	@sudo echo "127.0.0.1 mrios-he.42.fr" >> /etc/hosts
	@sudo echo "127.0.0.1 hugo.mrios-he.42.fr" >> /etc/hosts

$(NAME):
	@docker-compose -f srcs/docker-compose.yml up --build -d

clean:
	@docker-compose -f srcs/docker-compose.yml down --remove-orphans
	@docker network prune -f

fclean: clean
	@docker system prune -af
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/mrios-he/data/wordpress/*
	@sudo rm -rf /home/mrios-he/data/mariadb/*
	@sudo rm -rf /home/mrios-he/data/hugo/*
	@docker network prune -f

rebuild:
	@docker-compose -f srcs/docker-compose.yml down --remove-orphans
	@docker network prune -f
	@docker-compose -f srcs/docker-compose.yml up --build -d

re: fclean all

.PHONY: all clean fclean re prepare rebuild