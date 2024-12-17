FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y wget make gcc procps && \
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

# Create redis configuration directory
RUN mkdir -p /usr/local/etc/redis

# Copy configuration file
COPY conf/redis.conf /usr/local/etc/redis/redis.conf

# Set vm.overcommit_memory
RUN echo "vm.overcommit_memory=1" >> /etc/sysctl.conf

EXPOSE 6379

# Add startup script
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]