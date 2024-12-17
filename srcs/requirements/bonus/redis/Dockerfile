FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y redis-server procps && \
    rm -rf /var/lib/apt/lists/*

# Create redis configuration directory
RUN mkdir -p /usr/local/etc/redis

# Copy configuration file
COPY conf/redis.conf /usr/local/etc/redis/redis.conf

EXPOSE 6379

# Add startup script
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]