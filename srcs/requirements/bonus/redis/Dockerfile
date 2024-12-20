FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y redis-server procps && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/etc/redis

COPY conf/redis.conf /usr/local/etc/redis/redis.conf

EXPOSE 6379

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]