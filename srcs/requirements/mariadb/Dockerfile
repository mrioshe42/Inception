FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    mariadb-server \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql \
    && chmod 777 /var/run/mysqld \
    && chmod 777 /var/lib/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]