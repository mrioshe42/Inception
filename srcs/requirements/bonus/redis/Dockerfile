FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y wget make gcc && \
    wget http://download.redis.io/releases/redis-6.2.6.tar.gz && \
    tar xzf redis-6.2.6.tar.gz && \
    cd redis-6.2.6 && \
    make && \
    make install && \
    cd .. && \
    rm -rf redis-6.2.6* && \
    apt-get remove -y wget make gcc && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /usr/local/etc/redis

COPY conf/redis.conf /usr/local/etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]